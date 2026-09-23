import SwiftUI

/// Every person's photo in the app (feed cards, chat rows, profile headers)
/// goes through this one view instead of each screen re-implementing
/// `AsyncImage` + a fallback. The backend stores photo URLs, not bundled
/// asset names, so this replaces the original `Image("sandeep")` calls.
struct RemoteAvatarImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    var body: some View {
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case let .success(image):
                    image.resizable().aspectRatio(contentMode: contentMode)
                case .failure:
                    placeholder
                case .empty:
                    placeholder.overlay(ProgressView())
                @unknown default:
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.25)
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}
