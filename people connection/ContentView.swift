
import SwiftUI

struct ContentView: View {
    @State private var currentTab = 0
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            WelcomeView(nextAction: goNext)
                .tag(0)
            NameInputView(nextAction: goNext)
                .tag(1)
            AgeInputView(nextAction: goNext)
                .tag(2)
            GenderInputView(nextAction: goNext)
                .tag(3)
            MatchReadyView(
                nextAction: {
                print("Onboarding Complete! Navigate to Main App.")
            }
        )
            .tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
    
    func goNext() {
        withAnimation {
            currentTab += 1
        }
    }
}

#Preview {
    ContentView()
}
