import SwiftUI

struct HomeViewActions: View {
    var body: some View {
        VStack {
            brandlogo()
            HStack {
                Image("person.crop.circle")
//                userStories()
                stories()
            }
            .padding(.bottom)
//            .background(.blue)
            Spacer()
            VStack {
                Spacer()
            }
        }
    }
}

struct stories : View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<10) { _ in
                    Circle()
                        .font(.caption)
                        .frame(width: 100, height: 100)
                }
            }
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

struct brandlogo : View {
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .padding(8)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("Bumble")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Image(systemName: "slider.horizontal.3")
                .padding(8)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.title2)
        .fontWeight(.medium)
    }
}
#Preview {
    HomeViewActions()
}
