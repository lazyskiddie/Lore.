import Foundation

protocol APIClientProtocol: Sendable {
    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response
    func sendNoContent(_ endpoint: Endpoint) async throws
}
