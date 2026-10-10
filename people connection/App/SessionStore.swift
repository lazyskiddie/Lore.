import Foundation
import Observation

/// Drives `AppRootView`'s choice between the onboarding flow and the main
/// tab bar, and holds the signed-in person's profile so screens like
/// Profile/Chat don't each have to fetch "who am I" separately.
@Observable
@MainActor
final class SessionStore {
    private(set) var currentUser: User?
    private(set) var isAuthenticated: Bool

    init(hasStoredSession: Bool) {
        self.isAuthenticated = hasStoredSession
    }

    func didAuthenticate(as user: User) {
        currentUser = user
        isAuthenticated = true
    }

    func didUpdateProfile(_ user: User) {
        currentUser = user
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
}
