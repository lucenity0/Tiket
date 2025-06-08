import SwiftUI

enum SearchableItem {
    case movie(MovieItem)
    case sport(SportItem)
    case event(EventItem)

    var title: String {
        switch self {
        case .movie(let m): return m.title
        case .sport(let s): return s.title
        case .event(let e): return e.title
        }
    }

    var genre: String {
        switch self {
        case .movie(let m): return m.genre
        case .sport(let s): return s.genre
        case .event(let e): return e.genre
        }
    }

    var rating: String {
        switch self {
        case .movie(let m): return m.rating
        case .sport(let s): return s.rating
        case .event(let e): return e.rating
        }
    }

    var imageName: String {
        switch self {
        case .movie(let m): return m.imageName
        case .sport(let s): return s.imageName
        case .event(let e): return e.imageName
        }
    }
}
