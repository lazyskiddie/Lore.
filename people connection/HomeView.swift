import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            HomeViewActions()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Text("Search View")
                .tabItem {
                    Image(systemName: "safari")
                    Text("Explore")
                }
            
            Text("Profile View")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            Text("Notifications View")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alerts")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    HomeView()
}
