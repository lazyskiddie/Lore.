import SwiftUI

struct HomeFeedView: View {
    @State private var viewModel: HomeFeedViewModel

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: HomeFeedViewModel(discoveryRepository: dependencies.discoveryRepository))
    }

    var body: some View {
        VStack(spacing: 0) {
            BrandHeaderView()
            content
        }
        .task {
            await viewModel.loadFeedIfNeeded()
        }
        .alert(
            "It's a Match! 💜",
            isPresented: Binding(
                get: { viewModel.lastMatchedUser != nil },
                set: { isPresented in if !isPresented { viewModel.dismissMatchAlert() } }
            ),
            presenting: viewModel.lastMatchedUser
        ) { _ in
            Button("Keep Browsing", role: .cancel) { viewModel.dismissMatchAlert() }
        } message: { matchedUser in
            Text("You and \(matchedUser.name) both liked each other.")
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.profiles.isEmpty {
            LoadingView(message: "Finding people nearby…")
        } else if let errorMessage = viewModel.errorMessage, viewModel.profiles.isEmpty {
            FullScreenErrorView(message: errorMessage) {
                Task { await viewModel.loadFeed() }
            }
        } else if let topProfile = viewModel.profiles.first {
            ProfileCardView(
                user: topProfile,
                onPass: { Task { await viewModel.swipe(topProfile, action: .pass) } },
                onSuperLike: { Task { await viewModel.swipe(topProfile, action: .superLike) } },
                onLike: { Task { await viewModel.swipe(topProfile, action: .like) } }
            )
            .id(topProfile.id)
        } else {
            EmptyStateView(
                systemImage: "person.crop.circle.badge.questionmark",
                title: "No one new right now",
                message: "You've seen everyone for now. As more people join, they'll show up here — or use Search to find someone by name."
            )
        }
    }
}

#Preview {
    HomeFeedView(dependencies: .preview())
}
