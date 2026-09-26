import SwiftUI

struct NameInputView: View {
    @Bindable var viewModel: OnboardingViewModel
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 30) {
                Spacer()

                Text("What is Your Name?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                TextField("Enter your name here..", text: $viewModel.name)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .foregroundColor(.black)

                Spacer()

                PrimaryButton(title: "Next", isEnabled: viewModel.isNameValid, action: nextAction)
            }
            .padding()
        }
    }
}
