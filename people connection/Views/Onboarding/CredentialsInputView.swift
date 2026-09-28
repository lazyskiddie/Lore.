import SwiftUI

struct CredentialsInputView: View {
    @Bindable var viewModel: OnboardingViewModel
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 24) {
                Spacer()

                Text("Create your account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                VStack(spacing: 14) {
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)

                    SecureField("Password (min. 8 characters)", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 40)

                Spacer()

                PrimaryButton(title: "Next", isEnabled: viewModel.isCredentialsValid, action: nextAction)
            }
            .padding()
        }
    }
}
