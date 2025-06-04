import SwiftUI

struct PaymentViewS: View {
    let sport: SportItem
    let date: Date
    let time: String
    let seats: [String]

    @State private var selectedPaymentMethod = "UPI"
    @State private var showConfirmation = false
    @State private var navigateToTicket = false

    let paymentMethods = ["UPI", "Credit Card", "Debit Card", "Net Banking"]
    let ticketPrice = 120.0
    let privateTheatrePrice = 40000.0

    var isPrivateTheatre: Bool {
        seats.isEmpty
    }

    var totalPrice: Double {
        isPrivateTheatre ? privateTheatrePrice : Double(seats.count) * ticketPrice
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width

            ScrollView {
                VStack(spacing: 24) {

                    // 🏟️ Event Image
                    VStack {
                        Image(sport.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: width * 0.55)
                            .clipped()
                            .cornerRadius(12)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                    // 📋 Booking Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Confirm Your Booking")
                            .font(.title2)
                            .bold()

                        VStack(alignment: .leading, spacing: 12) {
                            Label(sport.title, systemImage: "sportscourt")
                            Label(formattedDate(date), systemImage: "calendar")
                            Label(time, systemImage: "clock")
                            if isPrivateTheatre {
                                Label("Private Theatre", systemImage: "house.fill")
                            } else {
                                Label(seats.joined(separator: ", "), systemImage: "ticket")
                            }
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Price Breakdown")
                                .font(.headline)

                            if isPrivateTheatre {
                                HStack {
                                    Text("Private Theatre Booking")
                                    Spacer()
                                    Text("₹\(Int(privateTheatrePrice))")
                                }
                            } else {
                                HStack {
                                    Text("\(seats.count) Ticket(s) x ₹\(Int(ticketPrice))")
                                    Spacer()
                                    Text("₹\(Int(totalPrice))")
                                }
                            }
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Payment Method")
                                .font(.headline)

                            Picker("Payment Method", selection: $selectedPaymentMethod) {
                                ForEach(paymentMethods, id: \.self) { method in
                                    Text(method)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        Button(action: {
                            showConfirmation = true
                        }) {
                            Text("Pay ₹\(Int(totalPrice)) Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .background(Color(red: 0.94, green: 0.89, blue: 0.85).ignoresSafeArea())
            .alert("Booking Confirmed 🎉", isPresented: $showConfirmation) {
                Button("OK") {
                    navigateToTicket = true
                }
            } message: {
                Text("Your booking for \(sport.title) on \(formattedDate(date)) at \(time) is confirmed.\nEnjoy the game!")
            }

            NavigationLink(
                destination: TicketDetailViewS(
                    sport: sport,
                    date: date,
                    time: time,
                    seats: seats
                ),
                isActive: $navigateToTicket
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
