import SwiftUI

struct MovieDetailView: View {
    let movie: MovieItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Header Banner
                ZStack(alignment: .topLeading) {
                    Image(movie.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 320)
                        .clipped()
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear]), startPoint: .top, endPoint: .center)
                        )

                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.6)))
                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)

                    VStack {
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Play Trailer")
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color(red: 69/255, green: 33/255, blue: 33/255))
                                .cornerRadius(25)
                            }

                            ForEach(["arrow.down.to.line", "airplayvideo", "square.and.arrow.up"], id: \.self) { icon in
                                Button(action: {}) {
                                    Image(systemName: icon)
                                        .foregroundColor(.black)
                                        .padding(10)
                                        .background(Circle().fill(Color.white))
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .padding()
                    }
                }

                // MARK: - Title & Info
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title)
                        .font(.title.bold())

                    Text(movie.duration ?? "1h 50min")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Genres
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(movie.genre.components(separatedBy: ", "), id: \.self) { genre in
                                Text(genre)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(movie.rating)/5")
                            .font(.subheadline)
                        Text("193k Votes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                // MARK: - About
                VStack(alignment: .leading, spacing: 10) {
                    Text("About the movie")
                        .font(.headline)

                    Text(movie.description ?? "No description available.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)

                // MARK: - Cast
                if let cast = movie.cast {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cast")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(cast) { member in
                                    VStack(spacing: 6) {
                                        Image(member.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            .shadow(radius: 3)

                                        Text(member.name)
                                            .font(.caption)
                                            .lineLimit(1)

                                        Text(member.role)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(width: 80)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Reviews
                if let review = movie.review {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Reviews")
                                .font(.headline)
                            Spacer()
                            Text("173k reviews")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                ForEach(review.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(10)
                                }
                            }

                            Text("“\(review.text)”")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            HStack {
                                Text("By \(review.author)")
                                    .bold()
                                Spacer()
                                HStack(spacing: 5) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(review.score)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.1), radius: 5)
                    }
                    .padding(.horizontal)
                }

                Spacer(minLength: 50)
            }
            .padding(.top)
        }
        .background(Color(red: 245/255, green: 234/255, blue: 226/255).edgesIgnoringSafeArea(.top))

        // MARK: - Booking Button
        .overlay(
            VStack {
                Spacer()
                NavigationLink(destination: BookingViewM(movie: movie)) {
                    Text("Booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 69/255, green: 33/255, blue: 33/255))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        .shadow(radius: 4)
                }
            }
        )
    }
}
