import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchMe() async throws -> User
    func fetchUser(id: String) async throws -> User
    func updateMe(name: String?, bio: String?, location: String?, interests: [String]?) async throws -> User
    /// Finds other people by name or city. Never includes the caller.
    func searchUsers(query: String, limit: Int, page: Int) async throws -> [User]
}

final class UserRepository: UserRepositoryProtocol, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchMe() async throws -> User {
        let dto: UserDTO = try await apiClient.send(Endpoint(path: "users/me"))
        return dto.toDomain()
    }

    func fetchUser(id: String) async throws -> User {
        let dto: UserDTO = try await apiClient.send(Endpoint(path: "users/\(id)"))
        return dto.toDomain()
    }

    func searchUsers(query: String, limit: Int = 20, page: Int = 0) async throws -> [User] {
        let endpoint = Endpoint(
            path: "users/search",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "page", value: String(page)),
            ]
        )
        let response: UserSearchResponseDTO = try await apiClient.send(endpoint)
        return response.users.map { $0.toDomain() }
    }

    func updateMe(name: String?, bio: String?, location: String?, interests: [String]?) async throws -> User {
        let body = UpdateProfileRequestDTO(name: name, bio: bio, location: location, interests: interests)
        let endpoint = Endpoint(path: "users/me", method: .patch, body: try Endpoint.encodedBody(body))
        let dto: UserDTO = try await apiClient.send(endpoint)
        return dto.toDomain()
    }
}
