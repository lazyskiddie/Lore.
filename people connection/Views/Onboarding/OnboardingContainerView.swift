import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentTab = 0
    @State private var viewModel: OnboardingViewModel
    @State private var isPresentingSignIn = false

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = State(initialValue: OnboardingViewModel(
            authRepository: dependencies.authRepository,
            sessionStore: dependencies.sessionStore
        ))
    }

    var body: some View {
        TabView(selection: $currentTab) {
            WelcomeView(nextAction: goNext, signInAction: { isPresentingSignIn = true })
                .tag(0)
            NameInputView(viewModel: viewModel, nextAction: goNext)
                .tag(1)
            AgeInputView(viewModel: viewModel, nextAction: goNext)
                .tag(2)
            GenderInputView(viewModel: viewModel, nextAction: goNext)
                .tag(3)
            CredentialsInputView(viewModel: viewModel, nextAction: goNext)
                .tag(4)
            MatchReadyView(viewModel: viewModel)
                .tag(5)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .sheet(isPresented: $isPresentingSignIn) {
            SignInView(dependencies: dependencies)
        }
    }

    private func goNext() {
        withAnimation {
            currentTab += 1
        }
    }
}

#Preview {
    OnboardingContainerView(dependencies: .preview())
}
