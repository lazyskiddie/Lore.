import SwiftUI

struct ProfileCardView: View {
    let user: User
    var onPass: () -> Void = {}
    var onSuperLike: () -> Void = {}
    var onLike: () -> Void = {}

    var body: some View {
        ZStack {
            ProfileDetailContent(user: user)

            VStack {
                Spacer()
                HStack(spacing: 20) {
                    ActionButton(icon: "xmark", color: .gray, action: onPass)
                    ActionButton(icon: "star.fill", color: .blue, small: true, action: onSuperLike)
                    ActionButton(icon: "heart.fill", color: .purple, action: onLike)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ProfileCardView(user: SampleData.priya)
}
