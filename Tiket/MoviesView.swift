import SwiftUI

import Foundation

struct MovieItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let genre: String
    let rating: String

    let duration: String?
    let description: String?
    let cast: [CastMember]?
    let review: ReviewItem?
}

struct CastMember: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let imageName: String
}

struct ReviewItem {
    let tags: [String]
    let text: String
    let author: String
    let score: String
}


struct GenreItem: Identifiable {
    let id = UUID()
    let imageName: String
    let genre: String
}

struct MoviesView: View {
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
                            NavigationLink(destination: SearchView()) {
                                HStack {
                                    Image(systemName:"magnifyingglass")
                                        .foregroundColor(.black)
                                    Text("Search here")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }

                            CarouselSection(items: carouselItems, width: width)

                            // Hot Genres Section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Hot Genres")
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
                                        ForEach(hotGenres) { genreItem in
                                            VStack {
                                                Image(genreItem.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle())

                                                Text(genreItem.genre)
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            // Movie Sections
                            ForEach(movieCategories, id: \.0) { category in
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
                                                NavigationLink(destination: MovieDetailView(movie: item)) {
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
        CarouselItem(imageName: "interstellar", title: "Interstellar"),
        CarouselItem(imageName: "blackpanther", title: "Black Panther"),
        CarouselItem(imageName: "wickedbanner", title: "Wicked"),
        CarouselItem(imageName: "bridgerton", title: "Bridgerton")
    ]
    // Hot genres as GenreItem list
    var hotGenres: [GenreItem] = [
        GenreItem(imageName: "nun2", genre: "Horror"),
        GenreItem(imageName: "homealone", genre: "Comedy"),
        GenreItem(imageName: "jw4", genre: "Crime"),
        GenreItem(imageName: "meg2", genre: "Action"),
        GenreItem(imageName: "wickedbanner", genre: "Fantasy"),
        GenreItem(imageName: "interstellar", genre: "Sci-Fi"),
        GenreItem(imageName: "snowwhite", genre: "Family"),
        GenreItem(imageName: "jjk", genre: "Anime")
    ]

    var movieCategories: [(String, [MovieItem])] = [
        ("Popular Now", [
            MovieItem(
                imageName: "meg2",
                title: "Meg 2: The Trench",
                genre: "Action, Crime",
                rating: "4.5",
                duration: "1h 56m",
                description: "An elite research team dives into the depths of the ocean only to face a colossal threat.",
                cast: [
                    CastMember(name: "Jason Statham", role: "Jonas Taylor", imageName: "jason"),
                    CastMember(name: "Cliff Curtis", role: "Mac", imageName: "cliff")
                ],
                review: ReviewItem(tags: ["Thrilling", "Shark", "Underwater"], text: "A non-stop aquatic thrill ride.", author: "Collider", score: "4.3")
            ),
            MovieItem(
                imageName: "nun2",
                title: "The Nun II",
                genre: "Horror, Fantasy",
                rating: "4.6",
                duration: "1h 50m",
                description: "Sister Irene confronts evil as the demon Valak returns in a haunting sequel.",
                cast: [
                    CastMember(name: "Taissa Farmiga", role: "Sister Irene", imageName: "taissa"),
                    CastMember(name: "Bonnie Aarons", role: "Valak", imageName: "bonnie")
                ],
                review: ReviewItem(tags: ["Scary", "Haunting", "Sequel"], text: "Even scarier than the first.", author: "IGN", score: "4.6")
            ),
            MovieItem(
                imageName: "wicked",
                title: "Wicked",
                genre: "Fantasy, Adventure",
                rating: "4.9",
                duration: "2h 12m",
                description: "The untold story of the witches of Oz.",
                cast: [
                    CastMember(name: "Ariana Grande", role: "Glinda", imageName: "ariana"),
                    CastMember(name: "Cynthia Erivo", role: "Elphaba", imageName: "cynthia")
                ],
                review: ReviewItem(tags: ["Magical", "Musical", "Wicked"], text: "Visually spectacular and emotionally resonant.", author: "Variety", score: "4.9")
            )
        ]),

        ("Family", [
            MovieItem(
                imageName: "brave",
                title: "Brave",
                genre: "Family, Action, Drama",
                rating: "4.3",
                duration: "1h 33m",
                description: "A Scottish princess defies tradition to carve her own path.",
                cast: [
                    CastMember(name: "Kelly Macdonald", role: "Merida", imageName: "kelly"),
                    CastMember(name: "Emma Thompson", role: "Queen Elinor", imageName: "emma")
                ],
                review: ReviewItem(tags: ["Empowering", "Family", "Adventure"], text: "A heartwarming tale of bravery.", author: "Screen Rant", score: "4.2")
            ),
            MovieItem(
                imageName: "tangled",
                title: "Tangled",
                genre: "Family, Romance",
                rating: "4.9",
                duration: "1h 40m",
                description: "A lost princess escapes her tower with a charming thief.",
                cast: [
                    CastMember(name: "Mandy Moore", role: "Rapunzel", imageName: "mandy"),
                    CastMember(name: "Zachary Levi", role: "Flynn Rider", imageName: "zachary")
                ],
                review: ReviewItem(tags: ["Romantic", "Adventure", "Musical"], text: "A fresh, modern fairy tale.", author: "The Guardian", score: "4.8")
            ),
            MovieItem(
                imageName: "elemental",
                title: "Elemental",
                genre: "Family, Drama, Romance",
                rating: "4.8",
                duration: "1h 49m",
                description: "Opposites attract in a city where fire, water, land, and air live together.",
                cast: [
                    CastMember(name: "Leah Lewis", role: "Ember", imageName: "leah"),
                    CastMember(name: "Mamoudou Athie", role: "Wade", imageName: "mamoudou")
                ],
                review: ReviewItem(tags: ["Beautiful", "Animated", "Diverse"], text: "A bold and emotional Pixar story.", author: "IndieWire", score: "4.7")
            ),
            MovieItem(
                imageName: "snowwhite",
                title: "Snow White",
                genre: "Fantasy, Adventure",
                rating: "2.9",
                duration: "1h 28m",
                description: "A princess escapes her evil stepmother and finds refuge with seven dwarves.",
                cast: [
                    CastMember(name: "Rachel Zegler", role: "Snow White", imageName: "rachel"),
                    CastMember(name: "Gal Gadot", role: "Evil Queen", imageName: "gal")
                ],
                review: ReviewItem(tags: ["Classic", "Reimagined"], text: "A mixed modern retelling of the classic.", author: "Empire", score: "2.9")
            )
        ]),

        ("Comedy", [
            MovieItem(
                imageName: "Minecraft",
                title: "A Minecraft Movie",
                genre: "Adventure, Fantasy, Sci-Fi",
                rating: "4.9",
                duration: "1h 42m",
                description: "A young hero must save the Overworld from a blocky threat.",
                cast: [
                    CastMember(name: "Jason Momoa", role: "Steve", imageName: "momoa")
                ],
                review: ReviewItem(tags: ["Fun", "Game Adaptation"], text: "Better than expected!", author: "GamesRadar", score: "4.5")
            ),
            MovieItem(
                imageName: "homealone",
                title: "Home Alone 2",
                genre: "Comedy, Family",
                rating: "4.9",
                duration: "2h 0m",
                description: "Kevin gets lost in New York and outsmarts two familiar crooks.",
                cast: [
                    CastMember(name: "Macaulay Culkin", role: "Kevin", imageName: "culkin"),
                    CastMember(name: "Joe Pesci", role: "Harry", imageName: "pesci")
                ],
                review: ReviewItem(tags: ["Holiday", "Classic", "Laughs"], text: "As charming and fun as the first.", author: "Chicago Tribune", score: "4.8")
            ),
            MovieItem(
                imageName: "bullettrain",
                title: "Bullet Train",
                genre: "Action, Comedy, Thriller",
                rating: "4.8",
                duration: "2h 6m",
                description: "Assassins on a high-speed train battle it out in Japan.",
                cast: [
                    CastMember(name: "Brad Pitt", role: "Ladybug", imageName: "brad"),
                    CastMember(name: "Aaron Taylor-Johnson", role: "Tangerine", imageName: "aaron")
                ],
                review: ReviewItem(tags: ["Stylish", "Violent", "Funny"], text: "Slick, stylish, and packed with punchlines.", author: "The Verge", score: "4.8")
            ),
            MovieItem(
                imageName: "cruella",
                title: "Cruella",
                genre: "Comedy, Drama",
                rating: "4.9",
                duration: "2h 14m",
                description: "The rebellious early days of the legendary Cruella de Vil.",
                cast: [
                    CastMember(name: "Emma Stone", role: "Cruella", imageName: "emma")
                ],
                review: ReviewItem(tags: ["Fashion", "Villain Origin"], text: "A bold, punk-rock origin story.", author: "IndieWire", score: "4.7")
            )
        ])
    ]

}
struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
}
// Carousel stub
struct CarouselSection: View {
    let items: [CarouselItem]
    let width: CGFloat

    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(items.indices, id: \.self) { index in
                ZStack(alignment: .bottom) {
                    // Image
                    Image(items[index].imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width * 0.9, height: width * 0.5)
                        .clipped()
                        .cornerRadius(15)
         

                    // Gradient + Title only at bottom
                    VStack(alignment: .leading, spacing: 4) {
                        Spacer()
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.9), .clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .clipped()
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .frame(width: width * 0.9, height: width * 0.3)
                        .frame(height: 80)
                        .overlay(
                            Text(items[index].title)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 10),
                            alignment: .bottomLeading
                        )
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                    }
                }
                .tag(index)
            }
        }
        .frame(height: width * 0.5)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }
}



struct TextOverlay: View {
    let title: String

    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(10)
                .padding()
        }
    }
}


#Preview {
    NavigationView {
        MoviesView()
    }
}
