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

            SearchView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            ChatListView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }

            MatchesView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Matches")
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
