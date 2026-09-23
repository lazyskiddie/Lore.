import SwiftUI

struct SignInView: View {
    @State private var viewModel: SignInViewModel
    @Environment(\.dismiss) private var dismiss

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: SignInViewModel(
            authRepository: dependencies.authRepository,
            sessionStore: dependencies.sessionStore
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                OnboardingBackground()

                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color(red: 0.95, green: 0.91, blue: 1.00))

                    Text("Welcome back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    VStack(spacing: 14) {
                        TextField("Email", text: $viewModel.email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)

                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 40)

                    InlineErrorText(message: viewModel.errorMessage)

                    Spacer()

                    PrimaryButton(
                        title: "Sign In",
                        isEnabled: viewModel.canSubmit,
                        isLoading: viewModel.isSubmitting
                    ) {
                        Task {
                            await viewModel.signIn()
                            if viewModel.errorMessage == nil { dismiss() }
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
    }
}
