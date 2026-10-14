import Foundation

/// A fully-described API request. Repositories build these; `APIClient`
/// turns them into `URLRequest`s. Keeping this as plain data (rather than
/// each repository building `URLRequest` by hand) is what makes it possible
/// to unit test repositories against a fake `APIClientProtocol` without any
/// networking at all.
struct Endpoint {
    var path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]?
    var body: Data?
    var requiresAuth: Bool = true

    static func encodedBody(_ value: some Encodable) throws -> Data {
        do {
            return try JSONEncoder.apiEncoder.encode(value)
        } catch {
            throw APIError.encodingFailed(String(describing: error))
        }
    }
}

extension JSONEncoder {
    static let apiEncoder = JSONEncoder()
}

extension JSONDecoder {
    static let apiDecoder = JSONDecoder()
}
