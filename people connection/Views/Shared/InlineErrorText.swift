import SwiftUI

/// A small, dismissable-by-nature (it disappears once `message` is cleared)
/// error line used under form fields. Kept intentionally quiet — it never
/// interrupts with an alert for routine validation/network hiccups.
struct InlineErrorText: View {
    let message: String?

    var body: some View {
        if let message {
            Text(message)
                .font(.footnote)
                .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .transition(.opacity)
        }
    }
}
