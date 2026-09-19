import SwiftUI

struct ActionButton: View {
    let icon: String
    let color: Color
    var small: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: small ? 20 : 26, weight: .bold))
                .foregroundColor(color)
                .frame(width: small ? 45 : 60, height: small ? 45 : 60)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 0)
        }
    }
}
