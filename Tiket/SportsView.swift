import SwiftUI
struct SportItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let genre: String
    let rating: String
}
struct SportsView: View {
    @State private var selectedTab: Tab = .movies
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let bottomInset = geo.safeAreaInsets.bottom

            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    // Top bar
                    VStack(spacing: height * 0.02) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .imageScale(.large)
                                    .padding(4)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                            }

                            Spacer()

                            Text("Explore")
                                .font(.system(size: width * 0.06, weight: .semibold))
                                .foregroundColor(.black)

                            Spacer()
                            Image(systemName: "slider.horizontal.3")
                                .opacity(0)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, height * 0.03)
                    .background(Color(red: 0.94, green: 0.89, blue: 0.85))

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.black)
                                Text("Search here")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundStyle(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)

                            CarouselSection(items: carouselItems, width: width)

                            // Hot Genres Section
                            

                            // Movie Sections
                            ForEach(SportCategories, id: \.0) { category in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(category.0)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("See All")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(category.1) { item in
                                                NavigationLink(destination: SportDetailView(sport: item)) {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        Image(item.imageName)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: width * 0.28, height: width * 0.42)
                                                            .clipped()
                                                            .cornerRadius(10)
                                                        
                                                        Text(item.title)
                                                            .font(.system(size: width * 0.035, weight: .semibold))
                                                            .foregroundColor(.black)
                                                            .lineLimit(1)
                                                        
                                                        Text(item.genre)
                                                            .font(.system(size: width * 0.03))
                                                            .foregroundColor(.gray)
                                                            .lineLimit(1)
                                                        
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "star.fill")
                                                                .foregroundColor(.yellow)
                                                                .font(.caption)
                                                            Text(item.rating)
                                                                .font(.caption)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                    .frame(width: width * 0.28)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 130)
                    }
                    .background(Color(red: 0.94, green: 0.89, blue: 0.85))
                }
                .background(Color(red: 0.94, green: 0.89, blue: 0.85))

                // Bottom Tab Bar
                ZStack {

                    Color(red: 0.32, green: 0.14, blue: 0.14)
                        .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea(edges: .bottom)

                    CustomTabBar(
                        selectedTab: $selectedTab,
                        safeAreaBottomInset: bottomInset,
                        navigate: { _ in }
                    )
                    
                    .padding(.horizontal)
                }
                
                .frame(height: bottomInset > 0 ? bottomInset + 70 : 80)
            }
            
            .ignoresSafeArea(edges: .bottom)
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    let carouselItems = [
        CarouselItem(imageName: "spotify", title: "Spotify Premium"),
        CarouselItem(imageName: "minecraftadd", title: "Buy Minecraft!"),
        CarouselItem(imageName: "booknow", title: "Book Events Now"),
        CarouselItem(imageName: "bridgerton", title: "Watch in Netflix")
    ]

    var SportCategories: [(String, [SportItem])] = [
        ("Now Showing", [
            SportItem(imageName: "football", title: "Champions League Final", genre: "Football, Sports", rating: "4.8"),
            SportItem(imageName: "basketball", title: "NBA All-Star Game", genre: "Basketball, Exhibition", rating: "4.6"),
            SportItem(imageName: "tennis", title: "Wimbledon Semifinals", genre: "Tennis, Singles", rating: "4.7"),
            SportItem(imageName: "IPL", title: "IPL Grand Finale", genre: "Cricket, T20", rating: "4.9")

        ]),
        ("Next Week", [
            SportItem(imageName: "basketball", title: "NBA All-Star Game", genre: "Basketball, Exhibition", rating: "4.6"),
            SportItem(imageName: "IPL", title: "IPL Grand Finale", genre: "Cricket, T20", rating: "4.9"),
            SportItem(imageName: "tennis", title: "Wimbledon Semifinals", genre: "Tennis, Singles", rating: "4.7"),
            SportItem(imageName: "football", title: "Champions League Final", genre: "Football, Sports", rating: "4.8")


        ]),
        ("Next Month", [
            SportItem(imageName: "IPL", title: "IPL Grand Review", genre: "Cricket, T20", rating: "4.9"),
            SportItem(imageName: "football", title: "Champions League Final", genre: "Football, Sports", rating: "4.8"),
            SportItem(imageName: "basketball", title: "NBA All-Star Game", genre: "Basketball, Exhibition", rating: "4.6"),
            SportItem(imageName: "tennis", title: "Wimbledon Semifinals", genre: "Tennis, Singles", rating: "4.7")


        ]),
    ]
}

#Preview {
    NavigationView {
        SportsView()
    }
}
