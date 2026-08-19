import SwiftUI

struct HomeViewActions: View {
    var body: some View {
        VStack {
            HStack {
                Image("person.crop.circle")
                userStories()
                stories()
            }
            .padding(.bottom)
            .background(.blue)
            Spacer()
            VStack {
                bodymain()
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

struct userStories : View {
    var body: some View {
        Image("person.crop.circle")
//            .frame(width: 100, height: 100)
    }
}

struct bodymain : View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview {
    HomeViewActions()
}
