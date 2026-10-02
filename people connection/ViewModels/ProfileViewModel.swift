import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var user: User?
    private(set) var isLoading = false
    var errorMessage: String?

    private let userRepository: UserRepositoryProtocol
    private let sessionStore: SessionStore

    init(userRepository: UserRepositoryProtocol, sessionStore: SessionStore) {
        self.userRepository = userRepository
        self.sessionStore = sessionStore
        self.user = sessionStore.currentUser
    }

    func loadIfNeeded() async {
        guard user == nil else { return }
        await load()
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let fetched = try await userRepository.fetchMe()
            user = fetched
            sessionStore.didUpdateProfile(fetched)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load your profile."
        }
    }
}
