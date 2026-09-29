import Foundation

struct Match: Identifiable, Equatable, Sendable {
    let id: String
    let matchedAt: Date
    let conversationId: String?
    let user: User
}
