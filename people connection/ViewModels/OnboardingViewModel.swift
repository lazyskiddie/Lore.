import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    var name: String = ""
    var age: String = ""
    var gender: Gender?
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

    var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isAgeValid: Bool {
        guard let value = Int(age) else { return false }
        return value >= 18 && value <= 120
    }

    var isCredentialsValid: Bool {
        email.contains("@") && email.contains(".") && password.count >= 8
    }

    func completeSignUp() async {
        guard let gender, let ageValue = Int(age) else { return }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let user = try await authRepository.register(
                email: email.trimmingCharacters(in: .whitespaces).lowercased(),
                password: password,
                name: name.trimmingCharacters(in: .whitespaces),
                birthdate: Self.birthdateString(forAge: ageValue),
                gender: gender
            )
            sessionStore.didAuthenticate(as: user)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Something went wrong. Please try again."
        }
    }

    /// The backend stores a birthdate, but this simplified onboarding only
    /// collects an age, so we synthesize a birthdate (Jan 1 of the
    /// appropriate year) that satisfies the same "at least 18" validation
    /// server-side.
    private static func birthdateString(forAge age: Int) -> String {
        let year = Calendar.current.component(.year, from: .now) - age
        return String(format: "%04d-01-01", year)
    }
}
