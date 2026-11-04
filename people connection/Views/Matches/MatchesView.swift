import SwiftUI

/// Everyone you've matched with. Replaces the old "Alerts" placeholder tab
/// with something backed by real data (the matches API).
struct MatchesView: View {
    @State private var viewModel: MatchesViewModel
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = State(initialValue: MatchesViewModel(matchRepository: dependencies.matchRepository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BrandHeaderView()

                Text("Matches")
                    .frame(maxWidth: .infinity)
                    .font(.largeTitle)
                    .bold()
                    .padding()

                content
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.matches.isEmpty {
            LoadingView(message: "Loading your matches…")
        } else if let errorMessage = viewModel.errorMessage, viewModel.matches.isEmpty {
            FullScreenErrorView(message: errorMessage) {
                Task { await viewModel.load() }
            }
        } else if viewModel.matches.isEmpty {
            EmptyStateView(
                systemImage: "heart",
                title: "No matches yet",
                message: "When you and someone else like each other, they'll show up here."
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.matches) { match in
                        if let conversationId = match.conversationId {
                            NavigationLink {
                                ChatDetailView(
                                    conversation: Conversation(
                                        conversationId: conversationId,
                                        matchId: match.id,
                                        otherUser: match.user,
                                        lastMessage: nil
                                    ),
                                    dependencies: dependencies
                                )
                            } label: {
                                MatchRowView(match: match)
                            }
                            .buttonStyle(.plain)
                        } else {
                            MatchRowView(match: match)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                await viewModel.load()
            }
        }
    }
}

struct MatchRowView: View {
    let match: Match

    var body: some View {
        HStack(spacing: 12) {
            RemoteAvatarImage(url: match.user.photoURLs.first)
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(match.user.name), \(match.user.age)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Matched \(match.matchedAt.formatted(.relative(presentation: .named)))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "bubble.left.fill")
                .foregroundColor(.purple)
                .padding(.trailing, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 68)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    MatchesView(dependencies: .preview())
}
