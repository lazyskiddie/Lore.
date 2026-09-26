import SwiftUI

struct GenderInputView: View {
    @Bindable var viewModel: OnboardingViewModel
    var nextAction: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 30) {
                Spacer()

                Text("What's your gender?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Picker("Select Gender", selection: $viewModel.gender) {
                    Text("Select Gender").tag(Gender?.none)
                    ForEach(Gender.allCases) { gender in
                        Text(gender.displayName).tag(Gender?.some(gender))
                    }
                }
                .pickerStyle(.menu)
                .tint(.purple)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 40)

                Spacer()

                PrimaryButton(title: "Next", isEnabled: viewModel.gender != nil, action: nextAction)
            }
            .padding()
        }
    }
}
