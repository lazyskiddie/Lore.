import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchMe() async throws -> User
    func fetchUser(id: String) async throws -> User
    func updateMe(name: String?, bio: String?, location: String?, interests: [String]?) async throws -> User
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

    func updateMe(name: String?, bio: String?, location: String?, interests: [String]?) async throws -> User {
        let body = UpdateProfileRequestDTO(name: name, bio: bio, location: location, interests: interests)
        let endpoint = Endpoint(path: "users/me", method: .patch, body: try Endpoint.encodedBody(body))
        let dto: UserDTO = try await apiClient.send(endpoint)
        return dto.toDomain()
    }
}
