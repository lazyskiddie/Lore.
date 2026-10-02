import Foundation

struct DiscoveryFeedResponseDTO: Decodable {
    let profiles: [UserDTO]
}

struct SwipeRequestDTO: Encodable {
    let targetUserId: String
    let action: SwipeAction
}

struct SwipeMatchDTO: Decodable {
    let id: String
    let userAId: String
    let userBId: String
    let createdAt: String
}

struct SwipeResponseDTO: Decodable {
    let matched: Bool
    let match: SwipeMatchDTO?
}
