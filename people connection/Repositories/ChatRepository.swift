import Foundation

protocol ChatRepositoryProtocol: Sendable {
    func fetchConversations() async throws -> [Conversation]
    func fetchMessages(conversationId: String, limit: Int, before: Date?) async throws -> [ChatMessage]
    func sendMessage(conversationId: String, content: String) async throws -> ChatMessage
}

final class ChatRepository: ChatRepositoryProtocol, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchConversations() async throws -> [Conversation] {
        let response: ConversationsListResponseDTO = try await apiClient.send(Endpoint(path: "conversations"))
        return response.conversations.map { $0.toDomain() }
    }

    func fetchMessages(conversationId: String, limit: Int = 50, before: Date? = nil) async throws -> [ChatMessage] {
        var queryItems = [URLQueryItem(name: "limit", value: String(limit))]
        if let before {
            queryItems.append(URLQueryItem(name: "before", value: ISO8601DateFormatter().string(from: before)))
        }
        let endpoint = Endpoint(path: "conversations/\(conversationId)/messages", queryItems: queryItems)
        let response: MessagesListResponseDTO = try await apiClient.send(endpoint)
        return response.messages.map { $0.toDomain() }
    }

    func sendMessage(conversationId: String, content: String) async throws -> ChatMessage {
        let body = SendMessageRequestDTO(content: content)
        let endpoint = Endpoint(
            path: "conversations/\(conversationId)/messages",
            method: .post,
            body: try Endpoint.encodedBody(body)
        )
        let dto: MessageDTO = try await apiClient.send(endpoint)
        return dto.toDomain()
    }
}
