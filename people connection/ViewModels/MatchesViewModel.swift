import Foundation
import Observation

@Observable
@MainActor
final class MatchesViewModel {
    private(set) var matches: [Match] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let matchRepository: MatchRepositoryProtocol

    init(matchRepository: MatchRepositoryProtocol) {
        self.matchRepository = matchRepository
    }

    /// Always refetches (new matches can appear any time), but only shows a
    /// full-screen spinner the first time, when there is nothing to show yet.
    func load() async {
        isLoading = matches.isEmpty
        errorMessage = nil
        defer { isLoading = false }
        do {
            matches = try await matchRepository.fetchMatches()
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Couldn't load your matches."
        }
    }
}
