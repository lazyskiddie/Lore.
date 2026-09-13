import SwiftUI

struct ChatViews: View {
    var body: some View {
        VStack {
            brandlogo()
            header()
            ScrollView {
                chatInterface()
                    
                    .onTapGesture {
                        
                    }
            }
            .padding(.horizontal)
        }
    }
}

struct header : View {
    var body: some View {
        Text("Chat")
            .frame(maxWidth: .infinity)
            .font(.largeTitle)
            .bold()
            .padding()
            .background(.purple)
    }
}

struct chatInterface : View {
        var body: some View {
            HStack(spacing: 12) {
                chatImage()
                VStack {
                    HStack() {
                        chatName()
                        Spacer()
                        UserStatus(isOnline: true)
                    }
                    .padding(.top, 10)
                    Spacer()
                }
                
                Spacer()
            }
            
            .frame(width: 400, height: 60)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
}

struct chatImage : View {
    let imageName: String = "sandeep"
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            .padding(8)
            .background(.white.opacity(0.001))
    }
}

struct chatName : View {
    let name = "Sandeep"
    var body: some View {
        Text("\(name)")
            .font(.headline)
    }
}

struct UserStatus : View {
    let isOnline: Bool
        
        var body: some View {
            HStack(spacing: 6) {
                
                Text(isOnline ? "Online" : "Offline")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 60, height: 20)
                    .background(isOnline ? Color.purple : Color.red).cornerRadius(20)
                
            }
        }
}

#Preview {
    ChatViews()
}

