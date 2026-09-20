import SwiftUI

/// Purely presentational for now — there's no "stories" concept in the
/// backend yet. Kept as visual polish matching the original design; wiring
/// this up to real content is a natural follow-on feature once the backend
/// grows a stories/status endpoint.
struct StoriesRowView: View {
    let currentUserPhotoURL: URL?
    let otherUsers: [User]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                UserStoryItem(photoURL: currentUserPhotoURL)
                ForEach(otherUsers) { user in
                    StoryItem(username: user.name, photoURL: user.photoURLs.first)
                }
            }
            .padding()
        }
    }
}

struct UserStoryItem: View {
    let photoURL: URL?

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                RemoteAvatarImage(url: photoURL)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: 2, y: 2)
            }

            Text("Your story")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StoryItem: View {
    let username: String
    let photoURL: URL?

    private let ringGradient = LinearGradient(
        colors: [.purple],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )

    var body: some View {
        VStack(spacing: 6) {
            RemoteAvatarImage(url: photoURL)
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .padding(3)
                .background(Circle().stroke(ringGradient, lineWidth: 3))

            Text(username)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .frame(width: 72)
    }
}
