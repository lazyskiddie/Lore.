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
    }
}

#Preview {
    AppRootView(dependencies: .preview())
}
