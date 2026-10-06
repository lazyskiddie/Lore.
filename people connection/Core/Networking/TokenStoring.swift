import Foundation

/// Persists the access/refresh token pair. The live implementation
/// (`KeychainTokenStore`) uses the Keychain, never `UserDefaults` — tokens
/// are credentials and `UserDefaults` is not encrypted at rest.
protocol TokenStoring: Sendable {
    func save(_ tokens: AuthTokens) throws
    func accessToken() throws -> String
    func currentRefreshToken() -> String?
    func clear()
}

/// Implemented by `AuthRepository`. `APIClient` holds a weak reference to
/// this so a 401 can trigger exactly one refresh-and-retry without the
/// networking layer needing to know anything about auth internals — this
/// breaks what would otherwise be a circular dependency between the API
/// client and the auth repository.
protocol TokenRefreshing: AnyObject, Sendable {
    func refreshTokens() async throws -> AuthTokens
}
