import Foundation
import Observation

@Observable
@MainActor
final class ChatListViewModel {
    private(set) var conversations: [Conversation] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let chatRepository: ChatRepositoryProtocol

    init(chatRepository: ChatRepositoryProtocol) {
        self.chatRepository = chatRepository
    }

    func loadIfNeeded() async {
        guard conversations.isEmpty else { return }
        await load()
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            conversations = try await chatRepository.fetchConversations()
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load your chats."
        }
    }
}
