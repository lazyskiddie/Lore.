import SwiftUI

struct ChatViews: View {
    var body: some View {
        VStack {
            brandlogo()
            header()
            ScrollView {
                
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

#Preview {
    ChatViews()
}
