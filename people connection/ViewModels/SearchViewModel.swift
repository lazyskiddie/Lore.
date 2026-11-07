import Foundation
import Observation

@Observable
@MainActor
final class SearchViewModel {
    var query: String = ""
    private(set) var results: [User] = []
    private(set) var isSearching = false
    /// True once the current query has completed at least one search.
    private(set) var hasSearched = false
    var errorMessage: String?
    /// Set when liking someone from their profile completes a mutual match.
    private(set) var lastMatchedUser: User?

    static let minimumQueryLength = 2

    private let userRepository: UserRepositoryProtocol
    private let discoveryRepository: DiscoveryRepositoryProtocol

    init(userRepository: UserRepositoryProtocol, discoveryRepository: DiscoveryRepositoryProtocol) {
        self.userRepository = userRepository
        self.discoveryRepository = discoveryRepository
    }

    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canSearch: Bool {
        trimmedQuery.count >= Self.minimumQueryLength
    }

    func search() async {
        let text = trimmedQuery
        guard text.count >= Self.minimumQueryLength else {
            results = []
            hasSearched = false
            errorMessage = nil
            return
        }

        isSearching = true
        errorMessage = nil
        if results.isEmpty { hasSearched = false }
        defer { isSearching = false }

        do {
            let found = try await userRepository.searchUsers(query: text, limit: 30, page: 0)
            // If the person kept typing while this was in flight, a newer
            // search owns the results — don't overwrite them with stale ones.
            guard text == trimmedQuery else { return }
            results = found
            hasSearched = true
        } catch {
            guard !Task.isCancelled, text == trimmedQuery else { return }
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't search right now."
        }
    }

    func swipe(_ user: User, action: SwipeAction) async {
        do {
            let result = try await discoveryRepository.swipe(targetUserId: user.id, action: action)
            // Already acted on this person — they shouldn't stay in the list.
            results.removeAll { $0.id == user.id }
            if result.matched {
                lastMatchedUser = user
            }
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't send that. Please try again."
        }
    }

    func dismissMatchAlert() {
        lastMatchedUser = nil
    }
}
