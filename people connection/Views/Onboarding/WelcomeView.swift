import SwiftUI

struct WelcomeView: View {
    var nextAction: () -> Void
    var signInAction: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack {
                Text("Welcome !!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .overlay(
                        Capsule(style: .continuous)
                            .frame(height: 5)
                            .offset(y: 5)
                            .foregroundColor(.white),
                        alignment: .bottom
                    )

                Image(systemName: "heart.text.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(Color(red: 0.95, green: 0.91, blue: 1.00))
                    .padding()

                Spacer()

                TypewriterText()

                Spacer()

                PrimaryButton(title: "Let's Start", action: nextAction)

                Button(action: signInAction) {
                    Text("Already have an account? Sign in")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.bottom, 8)
                }
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

/// Shared deep-purple backdrop for every onboarding screen.
struct OnboardingBackground: View {
    var body: some View {
        Color(red: 0.15, green: 0.05, blue: 0.20)
            .ignoresSafeArea()
    }
}

struct TypewriterText: View {
    let fullText = "Where chemistry finds you after the swipe.."
    @State private var displayedText: String = ""

    var body: some View {
        Text(displayedText)
            .font(.title)
            .bold()
            .multilineTextAlignment(.center)
            .padding(.bottom, 10)
            .task {
                await typeOutText()
            }
    }

    private func typeOutText() async {
        displayedText = ""
        for character in fullText {
            displayedText.append(character)
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}

#Preview {
    WelcomeView(nextAction: {}, signInAction: {})
}
