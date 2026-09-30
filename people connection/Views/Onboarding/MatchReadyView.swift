import SwiftUI

struct MatchReadyView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack {
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(red: 0.95, green: 0.91, blue: 1.00))
                        .padding(.top, 15)

                    Image(systemName: "heart.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 200)
                        .foregroundColor(Color(red: 1.00, green: 0.30, blue: 0.65))
                        .padding(.bottom, 50)

                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(red: 0.95, green: 0.91, blue: 1.00))
                        .padding(.top, 15)
                }

                Text("Find your match")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .overlay(
                        Capsule(style: .continuous)
                            .frame(height: 5)
                            .offset(y: 5)
                            .foregroundColor(.white),
                        alignment: .bottom
                    )

                Spacer()

                InlineErrorText(message: viewModel.errorMessage)
                    .padding(.bottom, 8)

                PrimaryButton(
                    title: "Create Account",
                    isEnabled: !viewModel.isSubmitting,
                    isLoading: viewModel.isSubmitting
                ) {
                    Task { await viewModel.completeSignUp() }
                }
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}
