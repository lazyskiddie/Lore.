
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

struct WelcomeView: View {
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            
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
                
                TypewriterText()
                
                Spacer()
                
                PrimaryButton(title: "Let's Start", action: nextAction)
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

// MARK: - Typewriter Text Component
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
    
    func typeOutText() async {
        displayedText = ""
        for character in fullText {
            displayedText.append(character)
            // 50_000_000 nanoseconds = 0.05 seconds delay per letter
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
    }
}

// MARK: Name Input
struct NameInputView: View {
    @State private var name: String = ""
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("What is Your Name?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                TextField("Enter your name here..", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .foregroundColor(.black)
                
                Spacer()
                
                PrimaryButton(title: "Next", action: nextAction)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(name.isEmpty ? 0.6 : 1.0)
            }
            .padding()
        }
    }
}

// MARK: Age Input
struct AgeInputView: View {
    @State private var age: String = ""
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("What is Your Age?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                TextField("Enter your age..", text: $age)
                    .keyboardType(.numberPad) // Only allow numbers
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .foregroundColor(.black)
                
                Spacer()
                
                PrimaryButton(title: "Next", action: nextAction)
                    .disabled(age.isEmpty)
                    .opacity(age.isEmpty ? 0.6 : 1.0)
            }
            .padding()
        }
    }
}

// MARK: Gender Selection
struct GenderInputView: View {
    @State private var gender: String = ""
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("What's your gender?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Picker("Select Gender", selection: $gender) {
                    Text("Select Gender").tag("")
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Non-Binary").tag("Non-Binary")
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
                
                PrimaryButton(title: "Next", action: nextAction)
                    .disabled(gender.isEmpty)
                    .opacity(gender.isEmpty ? 0.6 : 1.0)
            }
            .padding()
        }
    }
}

// MARK: Match Ready
struct MatchReadyView: View {
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea(.all)
            
            VStack {
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding(.top, 15)
                    
                    Image(systemName: "heart.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 200)
                        .foregroundColor(.black)
                        .padding(.bottom, 50)
                
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding(.top, 15)
                    
                }
                
                Text("Find your match")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .overlay(
                        Capsule(style: .continuous)
                            .frame(height: 5)
                            .offset(y: 5)
                            .foregroundColor(.white)
                        , alignment: .bottom
                    )
                
                Spacer()
                
                PrimaryButton(title: "Sign In", action: nextAction)
            }
            .foregroundColor(.white)
            .padding()
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
