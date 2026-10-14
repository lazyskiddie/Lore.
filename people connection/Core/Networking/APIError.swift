import Foundation

/// The single error type every repository throws. Keeping this as one enum
/// (rather than letting `URLError`/`DecodingError` leak upward) means every
/// view model can `catch let error as APIError` and get a message that's
/// already safe to show a person, without knowing anything about HTTP.
enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case decodingFailed(String)
    case encodingFailed(String)
    case unauthorized
    case forbidden
    case notFound
    case conflict(String)
    case validationFailed(String)
    case rateLimited
    case server(String)
    case network(String)
    case unknown(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "That request couldn't be built. Please try again."
        case .invalidResponse:
            return "Received an unexpected response from the server."
        case .decodingFailed:
            return "Couldn't read the server's response. Please try again."
        case .encodingFailed:
            return "Couldn't prepare that request. Please try again."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .forbidden:
            return "You don't have access to that."
        case .notFound:
            return "We couldn't find that."
        case let .conflict(message), let .validationFailed(message), let .server(message):
            return message
        case .rateLimited:
            return "You're doing that a little too fast — please try again in a moment."
        case .network:
            return "Couldn't reach the server. Check your connection and try again."
        case let .unknown(statusCode):
            return "Something went wrong (code \(statusCode)). Please try again."
        }
    }

    /// True for errors where retrying the exact same request immediately is
    /// pointless (auth/validation problems) as opposed to transient ones.
    var isRetryable: Bool {
        switch self {
        case .network, .server, .unknown, .rateLimited:
            return true
        default:
            return false
        }
    }
}

/// Matches the backend's `{ error: { code, message, details? } }` shape.
struct APIErrorEnvelope: Decodable {
    struct Body: Decodable {
        let code: String
        let message: String
    }
    let error: Body
}
