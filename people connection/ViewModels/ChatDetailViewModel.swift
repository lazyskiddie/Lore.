import Foundation
import Observation

@Observable
@MainActor
final class ChatDetailViewModel {
    let conversation: Conversation
    private(set) var messages: [ChatMessage] = []
    private(set) var isLoading = false
    private(set) var isSending = false
    var draft: String = ""
    var errorMessage: String?

    private let chatRepository: ChatRepositoryProtocol
    private let currentUserId: String

    init(conversation: Conversation, chatRepository: ChatRepositoryProtocol, currentUserId: String) {
        self.conversation = conversation
        self.chatRepository = chatRepository
        self.currentUserId = currentUserId
    }

    func loadIfNeeded() async {
        guard messages.isEmpty else { return }
        await load()
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            messages = try await chatRepository.fetchMessages(
                conversationId: conversation.conversationId,
                limit: 50,
                before: nil
            )
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load messages."
        }
    }

    func send() async {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isSending else { return }

        draft = ""
        isSending = true
        defer { isSending = false }

        do {
            let message = try await chatRepository.sendMessage(
                conversationId: conversation.conversationId,
                content: text
            )
            messages.append(message)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't send that message."
            draft = text // restore so the person doesn't lose what they typed
        }
    }

    func isMine(_ message: ChatMessage) -> Bool {
        message.senderId == currentUserId
    }
}
