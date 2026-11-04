import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var user: User?
    private(set) var isLoading = false
    private(set) var isSaving = false
    var errorMessage: String?
    /// Shown inside the edit sheet when saving fails.
    var saveError: String?

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

    /// Saves edits to the person's own profile. Returns true on success.
    func save(name: String, bio: String, location: String, interestsText: String) async -> Bool {
        isSaving = true
        saveError = nil
        defer { isSaving = false }

        do {
            let updated = try await userRepository.updateMe(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                bio: bio.trimmingCharacters(in: .whitespacesAndNewlines),
                location: location.trimmingCharacters(in: .whitespacesAndNewlines),
                interests: Self.parseInterests(interestsText)
            )
            user = updated
            sessionStore.didUpdateProfile(updated)
            return true
        } catch {
            saveError = (error as? APIError)?.errorDescription ?? "Couldn't save your changes."
            return false
        }
    }

    /// "Hiking, coffee ,  Travel" -> ["Hiking", "coffee", "Travel"]
    /// (trimmed, blanks dropped, case-insensitive duplicates removed, capped to
    /// the server's limits of 20 interests of at most 40 characters each).
    static func parseInterests(_ text: String) -> [String] {
        var seen = Set<String>()
        var result: [String] = []
        for part in text.split(separator: ",") {
            let interest = String(part).trimmingCharacters(in: .whitespacesAndNewlines)
            guard !interest.isEmpty, interest.count <= 40, seen.insert(interest.lowercased()).inserted else { continue }
            result.append(interest)
            if result.count == 20 { break }
        }
        return result
    }
}
