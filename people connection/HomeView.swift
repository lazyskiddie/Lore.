import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            ZStack {
                Color.purple
                    .ignoresSafeArea()
                    .opacity(0.9)
                Text("Home View")
                    .foregroundColor(.white)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            Text("Search View")
                .tabItem {
                    Image(systemName: "safari")
                    Text("Explore")
                }
            
            Text("Notifications View")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alerts")
                }
            
            Text("Profile View")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
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
