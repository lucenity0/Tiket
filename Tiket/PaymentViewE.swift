import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PaymentViewE: View {
    let event: EventItem
    let date: Date
    let time: String
    let seats: [String]

    @State private var selectedPaymentMethod = "UPI"
    @State private var showConfirmation = false
    @State private var navigateToTicket = false

    let paymentMethods = ["UPI", "Credit Card", "Debit Card", "Net Banking"]
    let ticketPrice = 150.0
    let privateTheatrePrice = 40000.0

    var isPrivateTheatre: Bool {
        seats.isEmpty
    }

    var totalPrice: Double {
        isPrivateTheatre ? privateTheatrePrice : Double(seats.count) * ticketPrice
    }

    @Environment(\.colorScheme) var colorScheme
    let db = Firestore.firestore()

    let themeColor = Color(red: 0.32, green: 0.14, blue: 0.14)
    let backgroundColor = Color(red: 0.94, green: 0.89, blue: 0.85)

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width

            ScrollView {
                VStack(spacing: 24) {
                    VStack {
                        Image(event.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: width * 0.55)
                            .clipped()
                            .cornerRadius(12)
                    }
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Confirm Your Booking")
                            .font(.title2)
                            .bold()
                            .foregroundColor(themeColor)

                        VStack(alignment: .leading, spacing: 12) {
                            Label(event.title, systemImage: "music.note.list")
                            Label(formattedDate(date), systemImage: "calendar")
                            Label(time, systemImage: "clock")
                            if isPrivateTheatre {
                                Label("Private Theatre", systemImage: "house.fill")
                            } else {
                                Label(seats.joined(separator: ", "), systemImage: "ticket")
                            }
                        }.foregroundColor(.black)

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Price Breakdown")
                                .font(.headline)
                                .foregroundColor(themeColor)

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
                        }.foregroundColor(.black)

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Payment Method")
                                .font(.headline)
                                .foregroundColor(themeColor)

                            Picker("Payment Method", selection: $selectedPaymentMethod) {
                                ForEach(paymentMethods, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        Button(action: {
                            if let user = Auth.auth().currentUser {
                                let booking: [String: Any] = [
                                    "userId": user.uid,
                                    "title": event.title,
                                    "date": Timestamp(date: date),
                                    "time": time,
                                    "seats": seats,
                                    "type": "event",
                                    "timestamp": FieldValue.serverTimestamp()
                                ]
                                db.collection("bookings").addDocument(data: booking)
                            }
                            showConfirmation = true
                        }) {
                            Text("Pay ₹\(Int(totalPrice)) Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(themeColor)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .background(backgroundColor.ignoresSafeArea())
            .alert("Booking Confirmed 🎉", isPresented: $showConfirmation) {
                Button("OK") {
                    navigateToTicket = true
                }
            } message: {
                Text("Your booking for \(event.title) on \(formattedDate(date)) at \(time) is confirmed.")
            }

            NavigationLink(
                destination: TicketDetailViewE(
                    event: event,
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
