import SwiftUI

struct HomeViewActions: View {
    var body: some View {
        VStack(spacing: 0) {
            brandlogo()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        stories()
                    }
                    .padding(.bottom)
                    Spacer()
                    VStack {
                        ProfileView()
                        ProfileView()
                        ProfileView()
                        ProfileView()
                        ProfileView()
                        Spacer()
                    }
                }
            }
        }
    }
}

struct stories : View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 16) {
                // user his story
                UserStoryItem()
                // others user story
                ForEach(1..<10) { index in
                    StoryItem(username: "user_\(index)")
                }
            }
            .padding()
        }
    }
}

struct UserStoryItem: View {
    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                // Blue Plus Badge
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: 2, y: 2)
            }
            
            Text("Your story")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StoryItem: View {
    var username: String
    
    let instaGradient = LinearGradient(
        colors: [.purple],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .foregroundColor(.gray.opacity(0.8))
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                // Creates the gap between the image and the ring
                .padding(3)
                .background(
                    Circle()
                        .stroke(instaGradient, lineWidth: 3)
                )
            
            Text(username)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

struct brandlogo : View {
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .padding(8)
                    .background(.white.opacity(0.001))
                    .onTapGesture {
                        
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("Lore.")
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Image(systemName: "slider.horizontal.3")
                .padding(8)
                .background(.white.opacity(0.001))
                .onTapGesture {
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.title2)
        .foregroundColor(Color(red: 0.96, green: 0.94, blue: 0.90))
        .padding(.bottom, 16)
        .background(Color(red: 0.15, green: 0.05, blue: 0.20))
    }
}
#Preview {
    HomeViewActions()
}
