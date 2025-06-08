import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Models

struct ContentItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let genre: String
    let rating: String
}

enum Tab: Hashable {
    case home, movies, tickets, sports
}

// MARK: - Main View

struct HomePageView: View {
    let movieItems = [
        ContentItem(imageName: "meg2", title: "Meg 2: The Trench", genre: "Action, Crime", rating: "4.5"),
        ContentItem(imageName: "nun2", title: "The Nun II", genre: "Horror", rating: "4.5"),
        ContentItem(imageName: "jw4", title: "John Wick 4", genre: "Action, Neo-noir", rating: "4.5"),
        ContentItem(imageName: "wicked", title: "Wicked", genre: "Action, Drama, Family", rating: "4.5"),
        ContentItem(imageName: "fastx", title: "Fast X", genre: "Action, Neo-noir", rating: "4.5")
    ]

    let eventItems = [
        ContentItem(imageName: "comedyevent", title: "Saturday Night", genre: "Comedy, Family", rating: "4.5"),
        ContentItem(imageName: "concert", title: "Concert Music", genre: "Music, Party", rating: "4.5"),
        ContentItem(imageName: "standup", title: "Stand Up Comedy", genre: "Comedy, Family", rating: "4.5"),
        ContentItem(imageName: "dance", title: "Dance Show", genre: "Fun, Entertainment", rating: "4.5"),
        ContentItem(imageName: "comedyevent", title: "Saturday Night 2", genre: "Comedy, Family", rating: "4.5")
    ]

    let sportItems = [
        ContentItem(imageName: "IPL", title: "IPL Finals 2025", genre: "Entertainment, Family", rating: "4.5"),
        ContentItem(imageName: "football", title: "Soccer Game", genre: "Entertainment, Family", rating: "4.5"),
    ]

    @State private var selectedTab: Tab = .home
    @State private var path = NavigationPath()
    @State private var userName: String = "Loading..."
    @State private var profileImageUrl: String? = nil

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let bottomInset = geometry.safeAreaInsets.bottom

                ZStack(alignment: .bottom) {
                    Color(red: 0.9, green: 0.85, blue: 0.81)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        // Header Section
                        VStack(spacing: screenHeight * 0.02) {
                            HStack(spacing: screenWidth * 0.04) {
                                Button {
                                    path.append("userView")
                                } label: {
                                    if let urlString = profileImageUrl,
                                       let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
                                                    .clipShape(Circle())
                                            case .failure(_):
                                                Image("userAvatar")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
                                                    .clipShape(Circle())
                                            @unknown default:
                                                Image("userAvatar")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
                                                    .clipShape(Circle())
                                            }
                                        }
                                    } else {
                                        Image("userAvatar")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
                                            .clipShape(Circle())
                                    }
                                }

                                VStack(alignment: .leading) {
                                    Text("Hi, \(userName)")
                                        .font(.system(size: screenWidth * 0.05, weight: .semibold))
                                        .foregroundColor(.black)

                                    Text("Book your seats now!")
                                        .font(.system(size: screenWidth * 0.035))
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding(.horizontal, screenWidth * 0.05)
                        }
                        .padding(.top, screenHeight * 0.025)
                        .background(Color(red: 0.9, green: 0.85, blue: 0.81))
                        .zIndex(1)

                        // Scrollable Sections
                        ScrollView(.vertical, showsIndicators: false) {
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
                                .padding(.horizontal, screenWidth * 0.05)
                            }

                            VStack(spacing: screenHeight * 0.03) {
                                SectionScroll(title: "Movies : Now Showing", items: movieItems, destination: MoviesView())
                                SectionScroll(title: "Events : Now Showing", items: eventItems, destination: EventsView())
                                SectionScroll(title: "Sports : Now Showing", items: sportItems, destination: SportsView())

                                Spacer(minLength: screenHeight * 0.1)
                            }
                            .padding(.top, screenHeight * 0.02)
                            .padding(.bottom, 90)
                        }
                    }

                    // Custom Bottom Tab Bar
                    VStack(spacing: 0) {
                        ZStack {
                            Color(red: 0.32, green: 0.14, blue: 0.14)
                                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                                .ignoresSafeArea(edges: .bottom)

                            CustomTabBar(
                                selectedTab: $selectedTab,
                                safeAreaBottomInset: bottomInset,
                                navigate: { tab in
                                    if tab != selectedTab {
                                        switch tab {
                                        case .home:
                                            path.removeLast(path.count)
                                        case .movies:
                                            path.append("movies")
                                        case .tickets:
                                            path.append("tickets")
                                        case .sports:
                                            path.append("sports")
                                        }
                                        selectedTab = tab
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                        .frame(height: bottomInset)
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                    case "movies":
                        MoviesView()
                    case "tickets":
                        EventsView()
                    case "sports":
                        SportsView()
                    case "userView":
                        UserView()
                    default:
                        EmptyView()
                }
            }
            .onAppear(perform: fetchUserData)
        }
    }

    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            userName = "Guest"
            profileImageUrl = nil
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                userName = data["username"] as? String ?? "User"
                profileImageUrl = data["profileImageUrl"] as? String
            } else {
                userName = "User"
                profileImageUrl = nil
            }
        }
    }
}

// MARK: - Tab Bar Components

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var safeAreaBottomInset: CGFloat
    var navigate: (Tab) -> Void

    var body: some View {
        HStack(spacing: 50) {
            TabBarItem(icon: "house.fill", label: "Home", tab: .home, selectedTab: $selectedTab, navigate: navigate)
            TabBarItem(icon: "film.fill", label: "Movies", tab: .movies, selectedTab: $selectedTab, navigate: navigate)
            TabBarItem(icon: "ticket.fill", label: "Tickets", tab: .tickets, selectedTab: $selectedTab, navigate: navigate)
            TabBarItem(icon: "sportscourt", label: "Sports", tab: .sports, selectedTab: $selectedTab, navigate: navigate)
        }
        .foregroundColor(.white)
        .padding(.top, 30)
        .padding(.bottom, safeAreaBottomInset > 0 ? safeAreaBottomInset : 10)
        .frame(maxWidth: .infinity)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let tab: Tab
    @Binding var selectedTab: Tab
    let navigate: (Tab) -> Void

    var body: some View {
        Button {
            navigate(tab)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                Text(label)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Section Scroll

struct SectionScroll<Destination: View>: View {
    let title: String
    let items: [ContentItem]
    let destination: Destination

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))

                    Spacer()

                    NavigationLink(destination: destination) {
                        Text("View All")
                            .font(.footnote)
                            .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
                    }
                }
                .padding(.horizontal, width * 0.05)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: width * 0.03) {
                        ForEach(items) { item in
                            NavigationLink(destination: destination) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Image(item.imageName)
                                        .resizable()
                                        .aspectRatio(2/3, contentMode: .fill)
                                        .frame(width: width * 0.25, height: width * 0.375)
                                        .clipped()
                                        .cornerRadius(10)

                                    Text(item.title)
                                        .font(.system(size: width * 0.035, weight: .semibold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)

                                    Text(item.genre)
                                        .font(.system(size: width * 0.03))
                                        .foregroundColor(.black)
                                        .opacity(0.6)
                                        .lineLimit(1)
                                }
                                .frame(width: width * 0.25)
                            }
                        }
                    }
                    .padding(.horizontal, width * 0.05)
                }
            }
        }
        .frame(height: 240)
    }
}

// MARK: - Rounded Corner Shape

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Preview

#Preview {
    HomePageView()
}
