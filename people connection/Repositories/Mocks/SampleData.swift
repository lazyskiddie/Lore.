import Foundation

/// Deterministic sample data for SwiftUI previews and unit tests. Never
/// referenced by production networking code.
enum SampleData {
    static let currentUser = User(
        id: "me",
        email: "sandeep@example.com",
        name: "Sandeep Singh",
        age: 23,
        gender: .male,
        bio: "Software engineer by day, exploring hiking trails by weekend. Love a good cup of coffee and meaningful conversations.",
        location: "Surat, Gujarat",
        interests: ["Travel", "Hiking", "Coding", "Coffee", "Live Music", "Fitness"],
        photoURLs: [],
        createdAt: .now
    )

    static let priya = User(
        id: "priya",
        email: "priya@example.com",
        name: "Priya Mehta",
        age: 25,
        gender: .female,
        bio: "Product designer, weekend baker, and amateur astronomer.",
        location: "Ahmedabad, Gujarat",
        interests: ["Design", "Baking", "Astronomy", "Reading"],
        photoURLs: [],
        createdAt: .now
    )

    static let arjun = User(
        id: "arjun",
        email: "arjun@example.com",
        name: "Arjun Patel",
        age: 27,
        gender: .male,
        bio: "Runs marathons slowly and enthusiastically.",
        location: "Vadodara, Gujarat",
        interests: ["Running", "Street Food", "Photography"],
        photoURLs: [],
        createdAt: .now
    )

    static let neha = User(
        id: "neha",
        email: "neha@example.com",
        name: "Neha Shah",
        age: 25,
        gender: .female,
        bio: "Vet student who has never met a dog she didn't like.",
        location: "Surat, Gujarat",
        interests: ["Animals", "Guitar", "Travel"],
        photoURLs: [],
        createdAt: .now
    )

    static let feed: [User] = [priya, arjun, neha]

    static let matches: [Match] = [
        Match(id: "match-1", matchedAt: .now.addingTimeInterval(-3600), conversationId: "conversation-1", user: priya)
    ]

    static let conversations: [Conversation] = [
        Conversation(
            conversationId: "conversation-1",
            matchId: "match-1",
            otherUser: priya,
            lastMessage: ChatMessagePreview(
                content: "Hey! Loved your profile 👋",
                senderId: currentUser.id,
                createdAt: .now.addingTimeInterval(-1800)
            )
        )
    ]

    static let messages: [ChatMessage] = [
        ChatMessage(
            id: "message-1",
            conversationId: "conversation-1",
            senderId: currentUser.id,
            content: "Hey! Loved your profile 👋",
            createdAt: .now.addingTimeInterval(-1800),
            readAt: nil
        ),
        ChatMessage(
            id: "message-2",
            conversationId: "conversation-1",
            senderId: priya.id,
            content: "Thank you! Yours too — hiking trails, nice.",
            createdAt: .now.addingTimeInterval(-1700),
            readAt: nil
        ),
    ]
}
