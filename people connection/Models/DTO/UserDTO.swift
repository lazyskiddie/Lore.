import Foundation

/// Mirrors `toUserDTO()` in the backend's `users.service.ts` field-for-field.
/// Never used directly by views — always mapped to `User` first.
struct UserDTO: Decodable {
    let id: String
    /// Present only on your own profile — the API never returns anyone else's email.
    let email: String?
    let name: String
    let age: Int
    let gender: Gender
    let bio: String
    let location: String
    let interests: [String]
    let photoUrls: [String]
    let createdAt: String

    func toDomain() -> User {
        User(
            id: id,
            email: email ?? "",
            name: name,
            age: age,
            gender: gender,
            bio: bio,
            location: location,
            interests: interests,
            photoURLs: photoUrls.compactMap(URL.init(string:)),
            createdAt: ISO8601Parsing.date(from: createdAt)
        )
    }
}

struct UserSearchResponseDTO: Decodable {
    let users: [UserDTO]
}
