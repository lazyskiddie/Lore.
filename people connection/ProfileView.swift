import SwiftUI

struct ProfileView: View {
    let name = "Sandeep Singh"
    let age = 22
    let location = "Surat, Gujarat"
    let bio = "Software engineer by day, exploring hiking trails by weekend. Love a good cup of coffee and meaningful conversations. Looking for someone to share new experiences with."
    let interests = ["Travel", "Hiking", "Coding", "Coffee", "Live Music", "Fitness"]
    
    let themeColor = Color.purple
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    ZStack(alignment: .bottomLeading) {
                        Image("sandeep")
                            .resizable()
                            .scaledToFill()
                        
                            .frame(width: UIScreen.main.bounds.width, height: 400)
//                            .frame(width: 400, height: 400)
                            .clipped()
                            .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.purple.opacity(0.1)]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    }
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "person.text.rectangle.fill")
                                    .foregroundColor(themeColor)
                                    .font(.title)
                                Text("About Me")
                                    .font(.title)
                                    .foregroundColor(.primary)
                            }
                            HStack {
                                Text("\(name)")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                            }
                            HStack {
                                Text("\(age),")
                                    .bold()
                                Image(systemName: "location.fill")
                                Text(location)
                            }
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(themeColor)
                                Text("Interests")
                                    .font(.headline)
                            }
                            
                            FlowLayout(mode: .wrap, items: interests) { interest in
                                Text(interest)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(themeColor.opacity(0.1))
                                    .foregroundColor(themeColor)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(themeColor.opacity(0.4), lineWidth: 1)
                                    )
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        
                        // Add some bottom padding so content isn't flush with edge
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
//                    .shadow(radius: 20)
                    .shadow(color: Color.purple.opacity(0.3), radius: 100, x: 0, y: 0)
                }
            }
            
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    ActionButton(icon: "xmark", color: .gray) {
                        print("Passed")
                    }
                    
                    ActionButton(icon: "star.fill", color: .blue, small: true) {
                        print("Superliked")
                    }
                    
                    ActionButton(icon: "heart.fill", color: themeColor) {
                        print("Liked")
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Helper Views & Extensions

// Reusable Action Button Component
struct ActionButton: View {
    let icon: String
    let color: Color
    var small: Bool = false
    let themeColor = Color.purple
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: small ? 20 : 26, weight: .bold))
                .foregroundColor(color)
                .frame(width: small ? 45 : 60, height: small ? 45 : 60)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(Circle())
//                .overlay(
//                    Circle()
//                        .stroke(themeColor.opacity(0.4), lineWidth: 1.5)
//                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 0)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct FlowLayout<T: Hashable, V: View>: View {
    let mode: LayoutMode
    let items: [T]
    let viewMapping: (T) -> V

    @State private var totalHeight: CGFloat = 0

    enum LayoutMode {
        var scrollable: Bool {
            switch self {
            case .scroll: return true
            case .wrap: return false
            }
        }
        case scroll
        case wrap
    }

    var body: some View {
        Group {
            if mode.scrollable {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(items, id: \.self) { item in
                            viewMapping(item)
                        }
                    }
                }
            } else {
                GeometryReader { geometry in
                    self.content(in: geometry)
                }
                .frame(height: totalHeight)
            }
        }
    }

    private func content(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.viewMapping(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if item == self.items.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}


#Preview {
    ProfileView()
}
