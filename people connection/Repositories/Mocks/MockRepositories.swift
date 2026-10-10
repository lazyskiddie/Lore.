import Foundation

/// Non-persistent token store used by preview/test dependencies, so
/// `KeychainTokenStore` (and the Simulator's Keychain) is never touched
/// outside of a real run.
final class InMemoryTokenStore: TokenStoring, @unchecked Sendable {
    private var tokens: AuthTokens?
    private let lock = NSLock()

    func save(_ tokens: AuthTokens) throws {
        lock.lock(); defer { lock.unlock() }
        self.tokens = tokens
    }

    func accessToken() throws -> String {
        lock.lock(); defer { lock.unlock() }
        guard let tokens else { throw APIError.unauthorized }
        return tokens.accessToken
    }

    func currentRefreshToken() -> String? {
        lock.lock(); defer { lock.unlock() }
        return tokens?.refreshToken
    }

    func clear() {
        lock.lock(); defer { lock.unlock() }
        tokens = nil
    }
}

final class MockAuthRepository: AuthRepositoryProtocol, @unchecked Sendable {
    var hasStoredSession = true
    var shouldFail = false

    func register(email: String, password: String, name: String, birthdate: String, gender: Gender) async throws -> User {
        if shouldFail { throw APIError.conflict("An account with this email already exists") }
        return SampleData.currentUser
    }

    func login(email: String, password: String) async throws -> User {
        if shouldFail { throw APIError.unauthorized }
        return SampleData.currentUser
    }

    func logout() async {}
}

final class MockUserRepository: UserRepositoryProtocol, @unchecked Sendable {
    func fetchMe() async throws -> User { SampleData.currentUser }
    func fetchUser(id: String) async throws -> User { SampleData.feed.first { $0.id == id } ?? SampleData.currentUser }
    func updateMe(name: String?, bio: String?, location: String?, interests: [String]?) async throws -> User {
        SampleData.currentUser
    }
}

final class MockDiscoveryRepository: DiscoveryRepositoryProtocol, @unchecked Sendable {
    func fetchFeed(limit: Int) async throws -> [User] { SampleData.feed }
    func swipe(targetUserId: String, action: SwipeAction) async throws -> SwipeResult {
        SwipeResult(matched: action != .pass, matchId: action != .pass ? "match-new" : nil)
    }
}

final class MockMatchRepository: MatchRepositoryProtocol, @unchecked Sendable {
    func fetchMatches() async throws -> [Match] { SampleData.matches }
}

final class MockChatRepository: ChatRepositoryProtocol, @unchecked Sendable {
    func fetchConversations() async throws -> [Conversation] { SampleData.conversations }
    func fetchMessages(conversationId: String, limit: Int, before: Date?) async throws -> [ChatMessage] {
        SampleData.messages
    }
    func sendMessage(conversationId: String, content: String) async throws -> ChatMessage {
        ChatMessage(
            id: UUID().uuidString,
            conversationId: conversationId,
            senderId: SampleData.currentUser.id,
            content: content,
            createdAt: .now,
            readAt: nil
        )
    }
}
