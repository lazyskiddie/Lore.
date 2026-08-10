
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

// MARK: Welcome
struct WelcomeView: View {
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.purple
            
            VStack {
                Text("Welcome !!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .overlay(
                        Capsule(style: .continuous)
                            .frame(height: 5)
                            .offset(y: 5)
                            .foregroundColor(.white)
                        , alignment: .bottom
                    )
                
                Image(systemName: "heart.text.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.black)
                    .padding()
                
                Spacer()
                
                PrimaryButton(title: "Let's Start", action: nextAction)
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

// MARK: Button Struct

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.white)
                .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

#Preview {
    ContentView()
}
