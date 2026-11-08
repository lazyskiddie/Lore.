import SwiftUI

/// Collects the person's real date of birth (replacing the old "age" field,
/// which forced the app to invent a birthday the person never gave).
struct BirthdateInputView: View {
    @Bindable var viewModel: OnboardingViewModel
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 24) {
                Spacer()

                Text("When's your birthday?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                DatePicker(
                    "Birthday",
                    selection: $viewModel.birthdate,
                    in: ...OnboardingViewModel.latestAllowedBirthdate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.colorScheme, .light)
                .background(Color.white)
                .cornerRadius(14)
                .padding(.horizontal, 30)

                Text("You're \(viewModel.ageInYears). You must be 18 or older to use Lore.")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                PrimaryButton(title: "Next", isEnabled: viewModel.isBirthdateValid, action: nextAction)
            }
            .padding()
        }
    }
}
