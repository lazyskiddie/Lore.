import Foundation

/// The composition root: the one place that knows every concrete type in
/// the app. Everywhere else — repositories, view models, views — depends
/// only on protocols, which is what makes `.preview()` (backed by
/// in-memory mocks) a drop-in replacement for SwiftUI previews and tests.
@MainActor
final class AppDependencies {
    let apiClient: URLSessionAPIClient?
    let tokenStore: TokenStoring
    let authRepository: AuthRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    let discoveryRepository: DiscoveryRepositoryProtocol
    let matchRepository: MatchRepositoryProtocol
    let chatRepository: ChatRepositoryProtocol
    let sessionStore: SessionStore

    /// Live dependencies talking to the real backend.
    init(environment: APIEnvironment = .current) {
        let tokenStore = KeychainTokenStore()
        let apiClient = URLSessionAPIClient(baseURL: environment.baseURL, tokenStore: tokenStore)
        let authRepository = AuthRepository(apiClient: apiClient, tokenStore: tokenStore)
        // Wired after construction to break the APIClient <-> AuthRepository
        // circular dependency (the client needs to trigger a refresh; the
        // refresher needs the client to make the refresh call).
        apiClient.tokenRefresher = authRepository

        self.tokenStore = tokenStore
        self.apiClient = apiClient
        self.authRepository = authRepository
        self.userRepository = UserRepository(apiClient: apiClient)
        self.discoveryRepository = DiscoveryRepository(apiClient: apiClient)
        self.matchRepository = MatchRepository(apiClient: apiClient)
        self.chatRepository = ChatRepository(apiClient: apiClient)
        self.sessionStore = SessionStore(hasStoredSession: authRepository.hasStoredSession)
    }

    /// In-memory mocks for SwiftUI previews and unit tests — no network,
    /// no Keychain, deterministic sample data.
    private init(mocked: Bool) {
        self.apiClient = nil
        self.tokenStore = InMemoryTokenStore()
        self.authRepository = MockAuthRepository()
        self.userRepository = MockUserRepository()
        self.discoveryRepository = MockDiscoveryRepository()
        self.matchRepository = MockMatchRepository()
        self.chatRepository = MockChatRepository()
        self.sessionStore = SessionStore(hasStoredSession: true)
        self.sessionStore.didAuthenticate(as: SampleData.currentUser)
    }

    static func preview() -> AppDependencies {
        AppDependencies(mocked: true)
    }
}
