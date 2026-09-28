import Foundation

/// The backend emits `Date.toISOString()`, which always includes
/// milliseconds (e.g. "2026-09-18T07:25:48.000Z"). `ISO8601DateFormatter`
/// requires `.withFractionalSeconds` to parse that, so this tries the
/// fractional format first and falls back to the plain one for safety.
enum ISO8601Parsing {
    private static let withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let standard: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    static func date(from string: String) -> Date {
        withFractionalSeconds.date(from: string) ?? standard.date(from: string) ?? .now
    }

    static func optionalDate(from string: String?) -> Date? {
        guard let string else { return nil }
        return withFractionalSeconds.date(from: string) ?? standard.date(from: string)
    }
}
