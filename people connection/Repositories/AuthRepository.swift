import Foundation

protocol AuthRepositoryProtocol: Sendable {
    func register(email: String, password: String, name: String, birthdate: String, gender: Gender) async throws -> User
    func login(email: String, password: String) async throws -> User
    func logout() async
    /// True if a token pair is currently stored — a cheap, synchronous check
    /// used at launch to decide whether to show onboarding or the home tab.
    var hasStoredSession: Bool { get }
}

/// Owns both the register/login/logout calls *and* token refresh
/// (`TokenRefreshing`), since both live behind the same `/auth` module on
/// the backend and both need the same `tokenStore`.
final class AuthRepository: AuthRepositoryProtocol, TokenRefreshing, @unchecked Sendable {
    private let apiClient: APIClientProtocol
    private let tokenStore: TokenStoring

    init(apiClient: APIClientProtocol, tokenStore: TokenStoring) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
    }

    var hasStoredSession: Bool {
        (try? tokenStore.accessToken()) != nil
    }

    func register(email: String, password: String, name: String, birthdate: String, gender: Gender) async throws -> User {
        let body = RegisterRequestDTO(email: email, password: password, name: name, birthdate: birthdate, gender: gender)
        let endpoint = Endpoint(
            path: "auth/register",
            method: .post,
            body: try Endpoint.encodedBody(body),
            requiresAuth: false
        )
        let response: AuthResponseDTO = try await apiClient.send(endpoint)
        try tokenStore.save(AuthTokens(accessToken: response.accessToken, refreshToken: response.refreshToken))
        return response.user.toDomain()
    }

    func login(email: String, password: String) async throws -> User {
        let body = LoginRequestDTO(email: email, password: password)
        let endpoint = Endpoint(
            path: "auth/login",
            method: .post,
            body: try Endpoint.encodedBody(body),
            requiresAuth: false
        )
        let response: AuthResponseDTO = try await apiClient.send(endpoint)
        try tokenStore.save(AuthTokens(accessToken: response.accessToken, refreshToken: response.refreshToken))
        return response.user.toDomain()
    }

    func logout() async {
        if let refreshToken = tokenStore.currentRefreshToken() {
            let body = RefreshTokenRequestDTO(refreshToken: refreshToken)
            let endpoint = Endpoint(
                path: "auth/logout",
                method: .post,
                body: try? Endpoint.encodedBody(body),
                requiresAuth: false
            )
            // Best-effort: even if this fails (offline, expired token), we
            // still clear local state so the person is signed out locally.
            try? await apiClient.sendNoContent(endpoint)
        }
        tokenStore.clear()
    }

    func refreshTokens() async throws -> AuthTokens {
        guard let refreshToken = tokenStore.currentRefreshToken() else {
            throw APIError.unauthorized
        }
        let body = RefreshTokenRequestDTO(refreshToken: refreshToken)
        let endpoint = Endpoint(
            path: "auth/refresh",
            method: .post,
            body: try Endpoint.encodedBody(body),
            requiresAuth: false
        )
        let response: TokenPairDTO = try await apiClient.send(endpoint)
        let tokens = AuthTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
        try tokenStore.save(tokens)
        return tokens
    }
}
