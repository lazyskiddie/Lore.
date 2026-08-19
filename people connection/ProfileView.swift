import SwiftUI

struct ProfileView: View {
    let name = "Sandeep Singh"
    let age = 22
    let username = "@Sand0208A"
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
                            .frame(width: UIScreen.main.bounds.width, height: 450)
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
                        VStack(alignment: .leading, spacing: 4) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(alignment: .firstTextBaseline) {
//                                        Image(systemName: "person.crop.circle.badge.checkmark.fill")
                                        Image(systemName: "person.crop.circle.fill")
                                            .foregroundColor(themeColor)
                                        Text("\(username)")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.black)
                                            .bold()
                                        
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.blue)
                                            .font(.headline)
                                    }
                                    Text("\(age)")
                                        .font(.system(.body, design: .monospaced))
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    HStack {
                                        Image(systemName: "location.fill")
                                        Text(location)
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.9))
                                }
                        }
                        .padding()
                        .frame(width: 300, height: 100)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.purple.opacity(0.3), radius: 100, x: 0, y: 0)
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            HStack {
                                Image(systemName: "person.text.rectangle.fill")
                                    .foregroundColor(themeColor)
                                    .font(.title)
                                Text("About Me")
                                    .font(.title)
                                    .foregroundColor(.primary)
                            }
                            Text("\(name)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.primary)
                            
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
                .font(.system(size: small ? 24 : 30, weight: .bold))
                .foregroundColor(color)
                .frame(width: small ? 60 : 75, height: small ? 60 : 75)
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


#Preview {
    ProfileView()
}
