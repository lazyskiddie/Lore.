import Foundation

/// Talks to the People Connection API over `URLSession`. Every method the
/// app needs funnels through `send`/`sendNoContent`, which centralizes:
/// attaching the bearer token, mapping HTTP status codes to `APIError`, and
/// transparently refreshing an expired access token exactly once before
/// giving up. No repository or view model deals with `URLRequest` directly.
final class URLSessionAPIClient: APIClientProtocol, @unchecked Sendable {
    private let baseURL: URL
    private let session: URLSession
    private let tokenStore: TokenStoring

    /// Set by `AppDependencies` right after `AuthRepository` is constructed.
    /// Weak because the client is a long-lived singleton while, in principle,
    /// the refresher shouldn't be forced to outlive it.
    weak var tokenRefresher: TokenRefreshing?

    init(baseURL: URL, session: URLSession = .shared, tokenStore: TokenStoring) {
        self.baseURL = baseURL
        self.session = session
        self.tokenStore = tokenStore
    }

    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        let data = try await performWithRefresh(endpoint)
        do {
            return try JSONDecoder.apiDecoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingFailed(String(describing: error))
        }
    }

    func sendNoContent(_ endpoint: Endpoint) async throws {
        _ = try await performWithRefresh(endpoint)
    }

    // MARK: - Private

    private func performWithRefresh(_ endpoint: Endpoint) async throws -> Data {
        do {
            return try await perform(endpoint)
        } catch APIError.unauthorized where endpoint.requiresAuth {
            guard let refresher = tokenRefresher else { throw APIError.unauthorized }
            // If this also fails, the refresh token itself is dead — let
            // that error (.unauthorized) propagate so the app signs out.
            _ = try await refresher.refreshTokens()
            return try await perform(endpoint)
        }
    }

    private func perform(_ endpoint: Endpoint) async throws -> Data {
        let request = try buildRequest(for: endpoint)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw mapError(statusCode: http.statusCode, data: data)
        }

        return data
    }

    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }
        components.queryItems = endpoint.queryItems

        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        if endpoint.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if endpoint.requiresAuth {
            guard let token = try? tokenStore.accessToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func mapError(statusCode: Int, data: Data) -> APIError {
        let serverMessage = (try? JSONDecoder.apiDecoder.decode(APIErrorEnvelope.self, from: data))?.error.message

        switch statusCode {
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 409: return .conflict(serverMessage ?? "That already exists.")
        case 400, 422: return .validationFailed(serverMessage ?? "Please check your input and try again.")
        case 429: return .rateLimited
        case 500...599: return .server(serverMessage ?? "The server ran into a problem.")
        default: return .unknown(statusCode: statusCode)
        }
    }
}
