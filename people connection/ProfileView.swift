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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileView()
}
