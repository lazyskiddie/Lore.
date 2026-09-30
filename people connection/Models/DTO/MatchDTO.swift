import Foundation

struct MatchSummaryDTO: Decodable {
    let id: String
    let matchedAt: String
    let conversationId: String?
    let user: UserDTO

    func toDomain() -> Match {
        Match(
            id: id,
            matchedAt: ISO8601Parsing.date(from: matchedAt),
            conversationId: conversationId,
            user: user.toDomain()
        )
    }
}

struct MatchesListResponseDTO: Decodable {
    let matches: [MatchSummaryDTO]
}
