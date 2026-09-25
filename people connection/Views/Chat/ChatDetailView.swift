import SwiftUI

struct ChatDetailView: View {
    @State private var viewModel: ChatDetailViewModel
    @FocusState private var isComposerFocused: Bool

    init(conversation: Conversation, dependencies: AppDependencies) {
        _viewModel = State(initialValue: ChatDetailViewModel(
            conversation: conversation,
            chatRepository: dependencies.chatRepository,
            currentUserId: dependencies.sessionStore.currentUser?.id ?? ""
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            messageList
            composer
        }
        .navigationTitle(viewModel.conversation.otherUser.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var messageList: some View {
        if viewModel.isLoading && viewModel.messages.isEmpty {
            LoadingView(message: "Loading messages…")
        } else if viewModel.messages.isEmpty {
            EmptyStateView(
                systemImage: "hand.wave",
                title: "Say hello",
                message: "You matched with \(viewModel.conversation.otherUser.name) — send the first message!"
            )
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, isMine: viewModel.isMine(message))
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _, _ in
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }

    private var composer: some View {
        VStack(spacing: 4) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            HStack(spacing: 8) {
                TextField("Message…", text: $viewModel.draft, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .focused($isComposerFocused)
                    .lineLimit(1...4)

                Button {
                    Task { await viewModel.send() }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.purple)
                }
                .disabled(
                    viewModel.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSending
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

private struct MessageBubble: View {
    let message: ChatMessage
    let isMine: Bool

    var body: some View {
        HStack {
            if isMine { Spacer(minLength: 40) }

            Text(message.content)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isMine ? Color.purple : Color(UIColor.secondarySystemGroupedBackground))
                .foregroundColor(isMine ? .white : .primary)
                .cornerRadius(18)

            if !isMine { Spacer(minLength: 40) }
        }
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(conversation: SampleData.conversations[0], dependencies: .preview())
    }
}
