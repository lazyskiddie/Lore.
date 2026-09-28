import Foundation

/// All fields optional to match `PATCH /users/me` semantics: only the keys
/// present are updated. Callers that don't want to touch a field simply
/// leave it `nil` rather than resending the current value.
struct UpdateProfileRequestDTO: Encodable {
    var name: String?
    var bio: String?
    var location: String?
    var interests: [String]?
}
