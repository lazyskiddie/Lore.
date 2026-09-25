import Foundation
import Observation

@Observable
@MainActor
final class HomeFeedViewModel {
    private(set) var profiles: [User] = []
    private(set) var isLoading = false
    var errorMessage: String?
    /// Set right after a swipe completes a mutual match, so the view can
    /// present a "It's a match!" alert; cleared via `dismissMatchAlert()`.
    private(set) var lastMatchedUser: User?

    private let discoveryRepository: DiscoveryRepositoryProtocol

    init(discoveryRepository: DiscoveryRepositoryProtocol) {
        self.discoveryRepository = discoveryRepository
    }

    func loadFeedIfNeeded() async {
        guard profiles.isEmpty else { return }
        await loadFeed()
    }

    func loadFeed() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            profiles = try await discoveryRepository.fetchFeed(limit: 20)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load profiles."
        }
    }

    func swipe(_ user: User, action: SwipeAction) async {
        profiles.removeAll { $0.id == user.id }
        do {
            let result = try await discoveryRepository.swipe(targetUserId: user.id, action: action)
            if result.matched {
                lastMatchedUser = user
            }
        } catch {
            // Non-fatal: the swipe not registering server-side shouldn't
            // block the feed — surface it quietly and let browsing continue.
            errorMessage = (error as? APIError)?.errorDescription
        }
    }

    func dismissMatchAlert() {
        lastMatchedUser = nil
    }
}
