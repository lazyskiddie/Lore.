import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: SearchViewModel(
            userRepository: dependencies.userRepository,
            discoveryRepository: dependencies.discoveryRepository
        ))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Search")
                .searchable(text: $viewModel.query, prompt: "Search by name or city")
                .autocorrectionDisabled()
                // Re-runs whenever the text changes and cancels the previous run,
                // so this is a debounce: only a pause in typing triggers a request.
                .task(id: viewModel.query) {
                    try? await Task.sleep(for: .milliseconds(350))
                    guard !Task.isCancelled else { return }
                    await viewModel.search()
                }
        }
        .alert(
            "It's a Match! 💜",
            isPresented: Binding(
                get: { viewModel.lastMatchedUser != nil },
                set: { isPresented in if !isPresented { viewModel.dismissMatchAlert() } }
            ),
            presenting: viewModel.lastMatchedUser
        ) { _ in
            Button("Great!", role: .cancel) { viewModel.dismissMatchAlert() }
        } message: { matchedUser in
            Text("You and \(matchedUser.name) both liked each other. Find them in your Chat tab.")
        }
    }

    @ViewBuilder
    private var content: some View {
        if !viewModel.canSearch {
            EmptyStateView(
                systemImage: "magnifyingglass",
                title: "Find people",
                message: "Search by name or city to find people who have joined Lore."
            )
        } else if !viewModel.results.isEmpty {
            List(viewModel.results) { user in
                NavigationLink {
                    SearchProfileDetailView(user: user) { action in
                        await viewModel.swipe(user, action: action)
                    }
                } label: {
                    SearchResultRow(user: user)
                }
            }
            .listStyle(.plain)
        } else if viewModel.isSearching || !viewModel.hasSearched {
            if let errorMessage = viewModel.errorMessage {
                FullScreenErrorView(message: errorMessage) {
                    Task { await viewModel.search() }
                }
            } else {
                LoadingView(message: "Searching…")
            }
        } else {
            EmptyStateView(
                systemImage: "person.crop.circle.badge.questionmark",
                title: "No one found",
                message: "Nobody matches “\(viewModel.trimmedQuery)”. Try a different name or city."
            )
        }
    }
}

struct SearchResultRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            RemoteAvatarImage(url: user.photoURLs.first)
                .frame(width: 52, height: 52)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text("\(user.name), \(user.age)")
                    .font(.headline)
                if !user.location.isEmpty {
                    Text(user.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

/// A read-only profile with the same pass / super-like / like actions as the
/// discovery feed, so anyone you find by searching can be liked directly.
struct SearchProfileDetailView: View {
    let user: User
    let onAction: (SwipeAction) async -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ProfileCardView(
            user: user,
            onPass: { act(.pass) },
            onSuperLike: { act(.superLike) },
            onLike: { act(.like) }
        )
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func act(_ action: SwipeAction) {
        Task {
            await onAction(action)
            dismiss()
        }
    }
}

#Preview {
    SearchView(dependencies: .preview())
}
