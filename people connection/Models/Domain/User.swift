import Foundation

struct User: Identifiable, Equatable, Sendable {
    let id: String
    let email: String
    let name: String
    let age: Int
    let gender: Gender
    let bio: String
    let location: String
    let interests: [String]
    let photoURLs: [URL]
    let createdAt: Date

    /// Used for onboarding previews and SwiftUI previews before any network
    /// call has completed.
    static let placeholder = User(
        id: "placeholder",
        email: "",
        name: "",
        age: 0,
        gender: .other,
        bio: "",
        location: "",
        interests: [],
        photoURLs: [],
        createdAt: .now
    )
}
