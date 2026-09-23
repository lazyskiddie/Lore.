import SwiftUI

struct BrandHeaderView: View {
    var onProfileTap: () -> Void = {}
    var onMenuTap: () -> Void = {}

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(.leading, 8)
                    .background(.white.opacity(0.001))
                    .onTapGesture(perform: onProfileTap)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("Lore.")
                .font(.system(size: 25, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(8)

            HStack {
                Image(systemName: "line.horizontal.3")
                    .padding(8)
                    .background(.white.opacity(0.001))
                    .onTapGesture(perform: onMenuTap)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.title2)
        .foregroundColor(Color(red: 0.96, green: 0.94, blue: 0.90))
        .background(Color(red: 0.15, green: 0.05, blue: 0.20))
    }
}

#Preview {
    BrandHeaderView()
}
