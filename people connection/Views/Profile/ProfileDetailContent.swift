import SwiftUI

/// The scrollable "About Me" + interests content, shared by the person's
/// own Profile tab and the swipeable discovery feed cards.
///
/// The original sized its header photo with `UIScreen.main.bounds.width`,
/// which ignores the view's actual layout context (Slide Over / Split View
/// on iPad, any future size-class change) and is deprecated. This reads the
/// real width from a `GeometryReader` instead.
struct ProfileDetailContent: View {
    let user: User
    private let themeColor: Color = .purple

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomLeading) {
                        RemoteAvatarImage(url: user.photoURLs.first)
                            .frame(width: geometry.size.width, height: 400)
                            .clipped()
                            .cornerRadius(25, corners: [.bottomLeft, .bottomRight])

                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.purple.opacity(0.1)]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    }
                }
                .frame(height: 400)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "person.text.rectangle.fill")
                                .foregroundColor(themeColor)
                                .font(.title)
                            Text("About Me")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                        HStack {
                            Text(user.name)
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.primary)
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                        }
                        HStack {
                            Text("\(user.age),")
                                .bold()
                            Image(systemName: "location.fill")
                            Text(user.location.isEmpty ? "Location not set" : user.location)
                        }
                        Text(user.bio.isEmpty ? "No bio yet." : user.bio)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(15)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(themeColor)
                            Text("Interests")
                                .font(.headline)
                        }

                        if user.interests.isEmpty {
                            Text("No interests added yet.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            FlowLayout(mode: .wrap, items: user.interests) { interest in
                                Text(interest)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(themeColor.opacity(0.1))
                                    .foregroundColor(themeColor)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(themeColor.opacity(0.4), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(15)

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .shadow(color: Color.purple.opacity(0.3), radius: 100, x: 0, y: 0)
            }
        }
    }
}

#Preview {
    ProfileDetailContent(user: SampleData.currentUser)
}
