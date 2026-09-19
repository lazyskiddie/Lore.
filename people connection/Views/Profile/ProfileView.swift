import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    private let onSignOut: () async -> Void

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: ProfileViewModel(
            userRepository: dependencies.userRepository,
            sessionStore: dependencies.sessionStore
        ))
        let authRepository = dependencies.authRepository
        let sessionStore = dependencies.sessionStore
        onSignOut = {
            await authRepository.logout()
            sessionStore.signOut()
        }
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()

            if let user = viewModel.user {
                ProfileDetailContent(user: user)
                    .ignoresSafeArea(edges: .top)
            } else if viewModel.isLoading {
                LoadingView(message: "Loading your profile…")
            } else if let errorMessage = viewModel.errorMessage {
                FullScreenErrorView(message: errorMessage) {
                    Task { await viewModel.load() }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(role: .destructive) {
                Task { await onSignOut() }
            } label: {
                Text("Sign Out")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.bordered)
            .padding()
            .background(.ultraThinMaterial)
        }
        .task {
            await viewModel.loadIfNeeded()
        }
        .refreshable {
            await viewModel.load()
        }
    }
}

#Preview {
    ProfileView(dependencies: .preview())
}
