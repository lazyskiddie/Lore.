import SwiftUI

/// A simple flow/wrap layout for chip-style content (e.g. interest tags).
///
/// Rewritten from the original: that version detected the last item with
/// `item == items.last!`, which crashes outright on an empty array and, for
/// any non-empty array containing a *duplicate* value, matches every
/// occurrence equal to the last element rather than only the final
/// position. This version tracks position by index instead of value
/// equality, so both problems are gone.
struct FlowLayout<T: Hashable, V: View>: View {
    enum LayoutMode {
        case scroll
        case wrap

        var scrollable: Bool {
            switch self {
            case .scroll: return true
            case .wrap: return false
            }
        }
    }

    let mode: LayoutMode
    let items: [T]
    let viewMapping: (T) -> V

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        Group {
            if items.isEmpty {
                EmptyView()
            } else if mode.scrollable {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                            viewMapping(item)
                        }
                    }
                }
            } else {
                GeometryReader { geometry in
                    content(in: geometry)
                }
                .frame(height: totalHeight)
            }
        }
    }

    private func content(in geometry: GeometryProxy) -> some View {
        var currentX: CGFloat = .zero
        var currentY: CGFloat = .zero
        let lastIndex = items.count - 1

        return ZStack(alignment: .topLeading) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                viewMapping(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading) { dimension in
                        if abs(currentX - dimension.width) > geometry.size.width {
                            currentX = 0
                            currentY -= dimension.height
                        }
                        let result = currentX
                        currentX = index == lastIndex ? 0 : currentX - dimension.width
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = currentY
                        if index == lastIndex { currentY = 0 }
                        return result
                    }
            }
        }
        .background(heightReader($totalHeight))
    }

    private func heightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let height = geometry.frame(in: .local).size.height
            if binding.wrappedValue != height {
                DispatchQueue.main.async {
                    binding.wrappedValue = height
                }
            }
            return .clear
        }
    }
}
