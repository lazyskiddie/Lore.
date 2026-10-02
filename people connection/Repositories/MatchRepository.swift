import Foundation

protocol MatchRepositoryProtocol: Sendable {
    func fetchMatches() async throws -> [Match]
}

final class MatchRepository: MatchRepositoryProtocol, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchMatches() async throws -> [Match] {
        let response: MatchesListResponseDTO = try await apiClient.send(Endpoint(path: "matches"))
        return response.matches.map { $0.toDomain() }
    }
}
