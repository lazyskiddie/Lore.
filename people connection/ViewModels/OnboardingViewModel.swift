import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    var name: String = ""
    var birthdate: Date = OnboardingViewModel.defaultBirthdate
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

    /// Where the date picker starts (it still has to be moved to the person's real birthday).
    static var defaultBirthdate: Date {
        Calendar.current.date(byAdding: .year, value: -25, to: .now) ?? .now
    }

    /// The newest birthday that still makes someone 18 today.
    static var latestAllowedBirthdate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: .now) ?? .now
    }

    var ageInYears: Int {
        Calendar.current.dateComponents([.year], from: birthdate, to: .now).year ?? 0
    }

    var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isBirthdateValid: Bool {
        (18...120).contains(ageInYears)
    }

    var isCredentialsValid: Bool {
        email.contains("@") && email.contains(".") && password.count >= 8
    }

    /// "yyyy-MM-dd" in the person's own calendar — exactly what the backend expects.
    var birthdateString: String {
        Self.birthdateFormatter.string(from: birthdate)
    }

    private static let birthdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func completeSignUp() async {
        guard let gender, isBirthdateValid else { return }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let user = try await authRepository.register(
                email: email.trimmingCharacters(in: .whitespaces).lowercased(),
                password: password,
                name: name.trimmingCharacters(in: .whitespaces),
                birthdate: birthdateString,
                gender: gender
            )
            sessionStore.didAuthenticate(as: user)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Something went wrong. Please try again."
        }
    }
}
