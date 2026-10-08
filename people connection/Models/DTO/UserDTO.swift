import Foundation

/// Mirrors `toUserDTO()` in the backend's  field-for-field.
/// Never used directly by views — always mapped to `User` first.
struct UserDTO: Decodable {
    let id: String
    let email: String
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
            email: email,
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
