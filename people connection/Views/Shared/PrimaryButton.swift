import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.purple)
                } else {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.purple)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.white)
            .cornerRadius(20)
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}
