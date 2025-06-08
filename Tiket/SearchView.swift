import SwiftUI

struct SearchView: View {
    // MARK: - Data Injected Locally (Full Data)
    let movieCategories: [(String, [MovieItem])] = [
        ("Popular Now", [
            MovieItem(imageName: "meg2", title: "Meg 2: The Trench", genre: "Action, Crime", rating: "4.5", duration: "1h 56m", description: "An elite research team dives into the depths of the ocean only to face a colossal threat.", cast: [CastMember(name: "Jason Statham", role: "Jonas Taylor", imageName: "jason"), CastMember(name: "Cliff Curtis", role: "Mac", imageName: "cliff")], review: ReviewItem(tags: ["Thrilling", "Shark", "Underwater"], text: "A non-stop aquatic thrill ride.", author: "Collider", score: "4.3")),
            MovieItem(imageName: "nun2", title: "The Nun II", genre: "Horror, Fantasy", rating: "4.6", duration: "1h 50m", description: "Sister Irene confronts evil as the demon Valak returns in a haunting sequel.", cast: [CastMember(name: "Taissa Farmiga", role: "Sister Irene", imageName: "taissa"), CastMember(name: "Bonnie Aarons", role: "Valak", imageName: "bonnie")], review: ReviewItem(tags: ["Scary", "Haunting", "Sequel"], text: "Even scarier than the first.", author: "IGN", score: "4.6")),
            MovieItem(imageName: "wicked", title: "Wicked", genre: "Fantasy, Adventure", rating: "4.9", duration: "2h 12m", description: "The untold story of the witches of Oz.", cast: [CastMember(name: "Ariana Grande", role: "Glinda", imageName: "ariana"), CastMember(name: "Cynthia Erivo", role: "Elphaba", imageName: "cynthia")], review: ReviewItem(tags: ["Magical", "Musical", "Wicked"], text: "Visually spectacular and emotionally resonant.", author: "Variety", score: "4.9"))
        ]),
        ("Family", [
            MovieItem(imageName: "brave", title: "Brave", genre: "Family, Action, Drama", rating: "4.3", duration: "1h 33m", description: "A Scottish princess defies tradition to carve her own path.", cast: [CastMember(name: "Kelly Macdonald", role: "Merida", imageName: "kelly"), CastMember(name: "Emma Thompson", role: "Queen Elinor", imageName: "emma")], review: ReviewItem(tags: ["Empowering", "Family", "Adventure"], text: "A heartwarming tale of bravery.", author: "Screen Rant", score: "4.2")),
            MovieItem(imageName: "tangled", title: "Tangled", genre: "Family, Romance", rating: "4.9", duration: "1h 40m", description: "A lost princess escapes her tower with a charming thief.", cast: [CastMember(name: "Mandy Moore", role: "Rapunzel", imageName: "mandy"), CastMember(name: "Zachary Levi", role: "Flynn Rider", imageName: "zachary")], review: ReviewItem(tags: ["Romantic", "Adventure", "Musical"], text: "A fresh, modern fairy tale.", author: "The Guardian", score: "4.8")),
            MovieItem(imageName: "elemental", title: "Elemental", genre: "Family, Drama, Romance", rating: "4.8", duration: "1h 49m", description: "Opposites attract in a city where fire, water, land, and air live together.", cast: [CastMember(name: "Leah Lewis", role: "Ember", imageName: "leah"), CastMember(name: "Mamoudou Athie", role: "Wade", imageName: "mamoudou")], review: ReviewItem(tags: ["Beautiful", "Animated", "Diverse"], text: "A bold and emotional Pixar story.", author: "IndieWire", score: "4.7")),
            MovieItem(imageName: "snowwhite", title: "Snow White", genre: "Fantasy, Adventure", rating: "2.9", duration: "1h 28m", description: "A princess escapes her evil stepmother and finds refuge with seven dwarves.", cast: [CastMember(name: "Rachel Zegler", role: "Snow White", imageName: "rachel"), CastMember(name: "Gal Gadot", role: "Evil Queen", imageName: "gal")], review: ReviewItem(tags: ["Classic", "Reimagined"], text: "A mixed modern retelling of the classic.", author: "Empire", score: "2.9"))
        ]),
        ("Comedy", [
            MovieItem(imageName: "Minecraft", title: "A Minecraft Movie", genre: "Adventure, Fantasy, Sci-Fi", rating: "4.9", duration: "1h 42m", description: "A young hero must save the Overworld from a blocky threat.", cast: [CastMember(name: "Jason Momoa", role: "Steve", imageName: "momoa")], review: ReviewItem(tags: ["Fun", "Game Adaptation"], text: "Better than expected!", author: "GamesRadar", score: "4.5")),
            MovieItem(imageName: "homealone", title: "Home Alone 2", genre: "Comedy, Family", rating: "4.9", duration: "2h 0m", description: "Kevin gets lost in New York and outsmarts two familiar crooks.", cast: [CastMember(name: "Macaulay Culkin", role: "Kevin", imageName: "culkin"), CastMember(name: "Joe Pesci", role: "Harry", imageName: "pesci")], review: ReviewItem(tags: ["Holiday", "Classic", "Laughs"], text: "As charming and fun as the first.", author: "Chicago Tribune", score: "4.8")),
            MovieItem(imageName: "bullettrain", title: "Bullet Train", genre: "Action, Comedy, Thriller", rating: "4.8", duration: "2h 6m", description: "Assassins on a high-speed train battle it out in Japan.", cast: [CastMember(name: "Brad Pitt", role: "Ladybug", imageName: "brad"), CastMember(name: "Aaron Taylor-Johnson", role: "Tangerine", imageName: "aaron")], review: ReviewItem(tags: ["Stylish", "Violent", "Funny"], text: "Slick, stylish, and packed with punchlines.", author: "The Verge", score: "4.8")),
            MovieItem(imageName: "cruella", title: "Cruella", genre: "Comedy, Drama", rating: "4.9", duration: "2h 14m", description: "The rebellious early days of the legendary Cruella de Vil.", cast: [CastMember(name: "Emma Stone", role: "Cruella", imageName: "emma")], review: ReviewItem(tags: ["Fashion", "Villain Origin"], text: "A bold, punk-rock origin story.", author: "IndieWire", score: "4.7"))
        ])
    ]
    
    let sportCategories: [(String, [SportItem])] = [
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
        ])
    ]
    
    let eventCategories: [(String, [EventItem])] = [
        ("Now Showing", [
            EventItem(imageName: "comedyevent", title: "Saturday Night", genre: "Comedy, Family", rating: "4.2"),
            EventItem(imageName: "concert", title: "Concert Music", genre: "Music, Party", rating: "4.3"),
            EventItem(imageName: "standup", title: "Stand Up Comedy", genre: "Comedy, Family", rating: "4.1"),
            EventItem(imageName: "dance", title: "Dance Show", genre: "Fun, Entertainment", rating: "4.0"),
            EventItem(imageName: "comedyevent", title: "Saturday Night 2", genre: "Comedy, Family", rating: "4.4")
        ]),
        ("Next Week", [
            EventItem(imageName: "dance", title: "Dance Show", genre: "Fun, Entertainment", rating: "4.0"),
            EventItem(imageName: "concert", title: "Concert Music", genre: "Music, Party", rating: "4.3"),
            EventItem(imageName: "comedyevent", title: "Saturday Night 2", genre: "Comedy, Family", rating: "4.4"),
            EventItem(imageName: "standup", title: "Stand Up Comedy", genre: "Comedy, Family", rating: "4.1"),
            EventItem(imageName: "comedyevent", title: "Saturday Night", genre: "Comedy, Family", rating: "4.2")
        ]),
        ("Next Month", [
            EventItem(imageName: "standup", title: "Stand Up Comedy", genre: "Comedy, Family", rating: "4.1"),
            EventItem(imageName: "comedyevent", title: "Saturday Night", genre: "Comedy, Family", rating: "4.2"),
            EventItem(imageName: "concert", title: "Concert Music", genre: "Music, Party", rating: "4.3"),
            EventItem(imageName: "dance", title: "Dance Show", genre: "Fun, Entertainment", rating: "4.0"),
            EventItem(imageName: "comedyevent", title: "Saturday Night 2", genre: "Comedy, Family", rating: "4.4")
        ])
    ]
    
    @State private var searchText = ""
        @State private var selectedGenre = "All"
        @State private var lastSearches = ["Avatar", "Film 2023", "Bridgerton", "Showman"]
        let genres = ["All", "Action", "Drama", "Comedy", "Romance", "Sports", "Fantasy", "Horror"]
        
        var filteredItems: [SearchableItem] {
            let allItems: [SearchableItem] =
            movieCategories.flatMap { $0.1.map { .movie($0) } } +
            sportCategories.flatMap { $0.1.map { .sport($0) } } +
            eventCategories.flatMap { $0.1.map { .event($0) } }
            
            return allItems.filter {
                (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)) &&
                (selectedGenre == "All" || $0.genre.localizedCaseInsensitiveContains(selectedGenre))
            }
        }
        
        @ViewBuilder
        func destinationView(for item: SearchableItem) -> some View {
            switch item {
            case .movie(let movie):
                MovieDetailView(movie: movie)
            case .sport(let sport):
                SportDetailView(sport: sport)
            case .event(let event):
                EventDetailView(event: event)
            }
        }
        
        var body: some View {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        TextField("Search here", text: $searchText)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    Text("Last Search").font(.headline)
                    FlowLayout(tags: lastSearches) { tag in
                        lastSearches.removeAll { $0 == tag }
                    }
                    
                    HStack {
                        Spacer()
                        Button("Clear All") {
                            lastSearches.removeAll()
                        }
                        .foregroundColor(.red)
                        .font(.subheadline)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(genres, id: \.self) { genre in
                                Button(action: {
                                    selectedGenre = genre
                                }) {
                                    Text(genre)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedGenre == genre ? Color.brown : Color(.systemGray5))
                                        .foregroundColor(selectedGenre == genre ? .white : .black)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredItems, id: \.title) { item in
                                NavigationLink(destination: destinationView(for: item)) {
                                    SearchResultCard(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
