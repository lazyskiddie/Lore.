import SwiftUI

struct ChatViews: View {
    var body: some View {
        VStack {
            brandlogo()
            header()
            ScrollView {
                chatInterface()
            }
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
        HStack {
            chatImage()
            Spacer()
        }
    }
}

struct chatImage : View {
    var body: some View {
        Image("sandeep")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding(8)
            .background(.white.opacity(0.001))
    }
}

#Preview {
    ChatViews()
}
