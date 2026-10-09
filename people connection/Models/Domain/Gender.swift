import Foundation

enum Gender: String, Codable, CaseIterable, Identifiable, Sendable {
    case male = "MALE"
    case female = "FEMALE"
    case nonBinary = "NON_BINARY"
    case other = "OTHER"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .male: "Male"
        case .female: "Female"
        case .nonBinary: "Non-Binary"
        case .other: "Other"
        }
    }
}
