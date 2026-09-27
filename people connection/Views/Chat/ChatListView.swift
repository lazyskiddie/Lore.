import SwiftUI

struct ChatListView: View {
    @State private var viewModel: ChatListViewModel
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = State(initialValue: ChatListViewModel(chatRepository: dependencies.chatRepository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BrandHeaderView()

                Text("Chat")
                    .frame(maxWidth: .infinity)
                    .font(.largeTitle)
                    .bold()
                    .padding()

                content
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.conversations.isEmpty {
            LoadingView(message: "Loading your chats…")
        } else if let errorMessage = viewModel.errorMessage, viewModel.conversations.isEmpty {
            FullScreenErrorView(message: errorMessage) {
                Task { await viewModel.load() }
            }
        } else if viewModel.conversations.isEmpty {
            EmptyStateView(
                systemImage: "bubble.left.and.bubble.right",
                title: "No conversations yet",
                message: "When you match with someone, you'll be able to chat here."
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.conversations) { conversation in
                        NavigationLink {
                            ChatDetailView(conversation: conversation, dependencies: dependencies)
                        } label: {
                            ChatRowView(conversation: conversation)
                        }
                        .buttonStyle(.plain)
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

#Preview {
    ChatListView(dependencies: .preview())
}
