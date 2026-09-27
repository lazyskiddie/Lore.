import SwiftUI

struct ChatRowView: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            RemoteAvatarImage(url: conversation.otherUser.photoURLs.first)
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.otherUser.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(conversation.lastMessage?.content ?? "Say hello 👋")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        // The original hardcoded `.frame(width: 400, height: 60)`, which
        // clips on any device narrower than 400pt. `maxWidth: .infinity`
        // lets the row fill whatever width its container actually has.
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}
