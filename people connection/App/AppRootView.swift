import SwiftUI

/// Replaces the original app's dead end: previously, finishing onboarding
/// called `print("Onboarding Complete! Navigate to Main App.")` and nothing
/// happened. This view is the actual navigation — it watches
/// `SessionStore.isAuthenticated` (flipped by a successful sign up or sign
/// in) and swaps the whole screen accordingly.
struct AppRootView: View {
    let dependencies: AppDependencies

    var body: some View {
        Group {
            if dependencies.sessionStore.isAuthenticated {
                HomeView(dependencies: dependencies)
                    .transition(.opacity)
            } else {
                OnboardingContainerView(dependencies: dependencies)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: dependencies.sessionStore.isAuthenticated)
        .task(id: dependencies.sessionStore.isAuthenticated) {
            await restoreSessionIfNeeded()
        }
    }

    /// On a relaunch the tokens are still in the Keychain, so the app starts
    /// "signed in" — but nobody has loaded *who* is signed in yet. Without
    /// this, screens that need your id (e.g. chat deciding which bubbles are
    /// yours) would see an empty user until you happened to open Profile.
    /// If the stored session is dead (refresh failed), sign out cleanly
    /// instead of leaving the person stuck in a broken signed-in state.
    private func restoreSessionIfNeeded() async {
        let session = dependencies.sessionStore
        guard session.isAuthenticated, session.currentUser == nil else { return }

        do {
            let me = try await dependencies.userRepository.fetchMe()
            session.didUpdateProfile(me)
        } catch APIError.unauthorized {
            await dependencies.authRepository.logout()
            session.signOut()
        } catch {
            // Offline or a transient server error: stay signed in; screens
            // that need the profile (e.g. Profile) retry on their own.
        }
    }
}

#Preview {
    AppRootView(dependencies: .preview())
}
