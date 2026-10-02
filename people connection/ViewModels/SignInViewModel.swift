import Foundation
import Observation

@Observable
@MainActor
final class SignInViewModel {
    var email: String = ""
    var password: String = ""
    private(set) var isSubmitting = false
    var errorMessage: String?

    private let authRepository: AuthRepositoryProtocol
    private let sessionStore: SessionStore

    init(authRepository: AuthRepositoryProtocol, sessionStore: SessionStore) {
        self.authRepository = authRepository
        self.sessionStore = sessionStore
    }

    var canSubmit: Bool {
        email.contains("@") && !password.isEmpty && !isSubmitting
    }

    func signIn() async {
        guard canSubmit else { return }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let user = try await authRepository.login(
                email: email.trimmingCharacters(in: .whitespaces).lowercased(),
                password: password
            )
            sessionStore.didAuthenticate(as: user)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Something went wrong. Please try again."
        }
    }
}
