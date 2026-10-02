import Foundation

struct SwipeResult: Equatable, Sendable {
    let matched: Bool
    let matchId: String?
}

protocol DiscoveryRepositoryProtocol: Sendable {
    func fetchFeed(limit: Int) async throws -> [User]
    func swipe(targetUserId: String, action: SwipeAction) async throws -> SwipeResult
}

final class DiscoveryRepository: DiscoveryRepositoryProtocol, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchFeed(limit: Int = 20) async throws -> [User] {
        let endpoint = Endpoint(
            path: "discovery/feed",
            queryItems: [URLQueryItem(name: "limit", value: String(limit))]
        )
        let response: DiscoveryFeedResponseDTO = try await apiClient.send(endpoint)
        return response.profiles.map { $0.toDomain() }
    }

    func swipe(targetUserId: String, action: SwipeAction) async throws -> SwipeResult {
        let body = SwipeRequestDTO(targetUserId: targetUserId, action: action)
        let endpoint = Endpoint(path: "discovery/swipe", method: .post, body: try Endpoint.encodedBody(body))
        let response: SwipeResponseDTO = try await apiClient.send(endpoint)
        return SwipeResult(matched: response.matched, matchId: response.match?.id)
    }
}
