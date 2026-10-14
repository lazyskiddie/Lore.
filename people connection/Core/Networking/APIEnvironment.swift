import Foundation

/// Which backend the app talks to. `current` is the one switch to flip when
/// pointing a build at staging/production — nothing else in the networking
/// or repository layers needs to change.
enum APIEnvironment {
    case development
    case staging
    case production

    var baseURL: URL {
        switch self {
        case .development:
            // iOS Simulator can reach the host machine's localhost directly.
            // A physical device needs your Mac's LAN IP here instead.
            return URL(string: "http://localhost:4000/api/v1")!
        case .staging:
            return URL(string: "https://staging-api.peopleconnection.example.com/api/v1")!
        case .production:
            return URL(string: "https://api.peopleconnection.example.com/api/v1")!
        }
    }

    static var current: APIEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}
