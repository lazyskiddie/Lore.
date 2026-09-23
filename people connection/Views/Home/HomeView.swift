import SwiftUI

struct HomeView: View {
    let dependencies: AppDependencies

    var body: some View {
        TabView {
            HomeFeedView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            Text("Explore coming soon")
                .tabItem {
                    Image(systemName: "safari")
                    Text("Explore")
                }

            ChatListView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }

            Text("Alerts coming soon")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alerts")
                }

            ProfileView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    HomeView(dependencies: .preview())
}
