import SwiftUI
import CoreImage.CIFilterBuiltins

struct TicketDetailViewS: View {
    let sport: SportItem
    let date: Date
    let time: String
    let seats: [String]
    let stadium = "National Stadium"

    @State private var navigateToHome = false

    var themeColor: Color {
        Color(red: 0.32, green: 0.14, blue: 0.14)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Ticket Details")
                .font(.title2)
                .bold()
                .foregroundColor(themeColor)

            VStack(spacing: 12) {
                Circle()
                    .fill(themeColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    )

                Text("Tickets Booked Successfully!")
                    .font(.headline)
                    .foregroundColor(themeColor)
            }

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    Image(sport.imageName)
                        .resizable()
                        .frame(width: 80, height: 110)
                        .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(sport.title)
                            .font(.headline)
                            .foregroundColor(.black)

                        Text(sport.genre)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Match Duration: 2 Hr")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Divider()

                Group {
                    HStack {
                        Text("STADIUM")
                        Spacer()
                        Text(stadium).bold()
                    }

                    HStack {
                        Text("DATE")
                        Spacer()
                        Text(formattedDate(date)).bold()
                    }

                    HStack {
                        Text("TIME")
                        Spacer()
                        Text(time).bold()
                    }

                    HStack {
                        Text("SEATS")
                        Spacer()
                        Text(seats.joined(separator: ", ")).bold()
                    }
                }
                .font(.subheadline)
                .foregroundColor(.black)

                Divider()

                BarcodeView(dataString: "\(seats.joined()).tiket.\(sport.title.replacingOccurrences(of: " ", with: ""))")
                    .padding(.top)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(red: 0.98, green: 0.96, blue: 0.93), Color(red: 0.93, green: 0.90, blue: 0.85)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            Spacer()

            NavigationLink(destination: HomePageView()
                            .navigationBarBackButtonHidden(true),
                           isActive: $navigateToHome) {
                EmptyView()
            }

            Button(action: {
                navigateToHome = true
            }) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .background(Color(red: 0.94, green: 0.89, blue: 0.85).ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigateToHome = true
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(themeColor)
                }
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
