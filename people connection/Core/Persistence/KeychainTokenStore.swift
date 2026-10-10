import Foundation
import Security

/// Stores the access/refresh token pair in the Keychain rather than
/// `UserDefaults` — these are credentials, and `UserDefaults` is plain-text
/// on disk. Access is synchronous (Keychain reads are fast, local, and the
/// rest of the app treats token lookup as a cheap, synchronous operation).
final class KeychainTokenStore: TokenStoring, @unchecked Sendable {
    private let service: String
    private let accessTokenAccount = "accessToken"
    private let refreshTokenAccount = "refreshToken"
    private let queue = DispatchQueue(label: "com.peopleconnection.keychain")

    init(service: String = Bundle.main.bundleIdentifier ?? "people-connection") {
        self.service = service
    }

    func save(_ tokens: AuthTokens) throws {
        try queue.sync {
            try setValue(tokens.accessToken, account: accessTokenAccount)
            try setValue(tokens.refreshToken, account: refreshTokenAccount)
        }
    }

    func accessToken() throws -> String {
        try queue.sync { try getValue(account: accessTokenAccount) }
    }

    func currentRefreshToken() -> String? {
        queue.sync { try? getValue(account: refreshTokenAccount) }
    }

    func clear() {
        queue.sync {
            deleteValue(account: accessTokenAccount)
            deleteValue(account: refreshTokenAccount)
        }
    }

    // MARK: - Keychain primitives

    private func setValue(_ value: String, account: String) throws {
        let data = Data(value.utf8)
        let query = baseQuery(account: account)

        let updateStatus = SecItemUpdate(
            query as CFDictionary,
            [kSecValueData as String: data] as CFDictionary
        )

        if updateStatus == errSecItemNotFound {
            var newItem = query
            newItem[kSecValueData as String] = data
            newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            let addStatus = SecItemAdd(newItem as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError.unhandled(status: addStatus)
            }
        } else if updateStatus != errSecSuccess {
            throw KeychainError.unhandled(status: updateStatus)
        }
    }

    private func getValue(account: String) throws -> String {
        var query = baseQuery(account: account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.unhandled(status: status)
        }
        return value
    }

    private func deleteValue(account: String) {
        SecItemDelete(baseQuery(account: account) as CFDictionary)
    }

    private func baseQuery(account: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }
}

enum KeychainError: Error, LocalizedError {
    case unhandled(status: OSStatus)

    var errorDescription: String? {
        switch self {
        case let .unhandled(status):
            return "Keychain error (status \(status))."
        }
    }
}
