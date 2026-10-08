import Foundation

// MARK: - Requests

struct RegisterRequestDTO: Encodable {
    let email: String
    let password: String
    let name: String
    /// "yyyy-MM-dd" — matches the backend's `z.coerce.date()` on a plain date string.
    let birthdate: String
    let gender: Gender
}

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct RefreshTokenRequestDTO: Encodable {
    let refreshToken: String
}

// MARK: - Responses

struct AuthResponseDTO: Decodable {
    let user: UserDTO
    let accessToken: String
    let refreshToken: String
}

struct TokenPairDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
