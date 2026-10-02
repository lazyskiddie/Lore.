import Foundation

struct LastMessageDTO: Decodable {
    let content: String
    let senderId: String
    let createdAt: String

    func toDomain() -> ChatMessagePreview {
        ChatMessagePreview(content: content, senderId: senderId, createdAt: ISO8601Parsing.date(from: createdAt))
    }
}

struct ConversationSummaryDTO: Decodable {
    let conversationId: String
    let matchId: String
    let otherUser: UserDTO
    let lastMessage: LastMessageDTO?

    func toDomain() -> Conversation {
        Conversation(
            conversationId: conversationId,
            matchId: matchId,
            otherUser: otherUser.toDomain(),
            lastMessage: lastMessage?.toDomain()
        )
    }
}

struct ConversationsListResponseDTO: Decodable {
    let conversations: [ConversationSummaryDTO]
}

struct MessageDTO: Decodable {
    let id: String
    let conversationId: String
    let senderId: String
    let content: String
    let createdAt: String
    let readAt: String?

    func toDomain() -> ChatMessage {
        ChatMessage(
            id: id,
            conversationId: conversationId,
            senderId: senderId,
            content: content,
            createdAt: ISO8601Parsing.date(from: createdAt),
            readAt: ISO8601Parsing.optionalDate(from: readAt)
        )
    }
}

struct MessagesListResponseDTO: Decodable {
    let messages: [MessageDTO]
}

struct SendMessageRequestDTO: Encodable {
    let content: String
}
