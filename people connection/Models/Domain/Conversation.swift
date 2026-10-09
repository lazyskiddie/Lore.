import Foundation

struct ChatMessagePreview: Equatable, Sendable {
    let content: String
    let senderId: String
    let createdAt: Date
}

struct Conversation: Identifiable, Equatable, Sendable {
    var id: String { conversationId }
    let conversationId: String
    let matchId: String
    let otherUser: User
    let lastMessage: ChatMessagePreview?
}

struct ChatMessage: Identifiable, Equatable, Sendable {
    let id: String
    let conversationId: String
    let senderId: String
    let content: String
    let createdAt: Date
    let readAt: Date?

    func isSender(_ userId: String) -> Bool { senderId == userId }
}
