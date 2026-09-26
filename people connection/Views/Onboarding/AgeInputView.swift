import SwiftUI

struct AgeInputView: View {
    @Bindable var viewModel: OnboardingViewModel
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 30) {
                Spacer()

                Text("What is Your Age?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                TextField("Enter your age..", text: $viewModel.age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .foregroundColor(.black)

                Text("You must be 18 or older to use Lore.")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                PrimaryButton(title: "Next", isEnabled: viewModel.isAgeValid, action: nextAction)
            }
            .padding()
        }
    }
}
