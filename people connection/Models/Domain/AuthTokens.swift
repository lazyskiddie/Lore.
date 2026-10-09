import Foundation

struct AuthTokens: Equatable, Sendable {
    let accessToken: String
    let refreshToken: String
}
