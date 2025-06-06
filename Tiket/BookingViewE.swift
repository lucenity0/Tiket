import SwiftUI

struct BookingViewE: View {
    let event: EventItem

    @State private var selectedDate = Date()
    @State private var selectedTime = "7:00 PM"
    @State private var selectedSeats: [String] = []

    let availableTimes = ["4:00 PM", "7:00 PM", "9:30 PM"]
    let seatRows = ["A", "B", "C", "D", "E"]
    let seatNumbers = [1, 2, 3, 4, 5, 6, 7, 8]

    let themeColor = Color(red: 0.32, green: 0.14, blue: 0.14)
    let lightCream = Color(red: 0.98, green: 0.96, blue: 0.93)
    let backgroundColor = Color(red: 0.94, green: 0.89, blue: 0.85)

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let maxWidth = min(geometry.size.width * 0.9, 500)

                ScrollView {
                    VStack(spacing: 24) {
                        // Date Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Date")
                                .font(.headline)
                                .foregroundStyle(.black)

                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding(4)
                                .background(lightCream)
                                .cornerRadius(12)
                                .colorScheme(.light) // Forces black text inside DatePicker
                        }
                        .frame(maxWidth: maxWidth)
                        .padding(.horizontal)

                        // Time Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Time")
                                .font(.headline)
                                .foregroundColor(themeColor)

                            HStack(spacing: 12) {
                                ForEach(availableTimes, id: \.self) { time in
                                    Button(action: {
                                        selectedTime = time
                                    }) {
                                        Text(time)
                                            .font(.system(size: 14, weight: .medium))
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 16)
                                            .background(selectedTime == time ? themeColor : Color.gray.opacity(0.2))
                                            .foregroundColor(selectedTime == time ? .white : themeColor)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: maxWidth, alignment: .leading)
                        .padding(.horizontal)

                        // Seat Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Seats")
                                .font(.headline)
                                .foregroundColor(themeColor)
                            
                            ForEach(seatRows, id: \.self) { row in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Row \(row)")
                                        .font(.subheadline)
                                        .foregroundColor(themeColor)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(seatNumbers, id: \.self) { number in
                                                let seat = "\(row)\(number)"
                                                Button(action: {
                                                    if selectedSeats.contains(seat) {
                                                        selectedSeats.removeAll { $0 == seat }
                                                    } else {
                                                        selectedSeats.append(seat)
                                                    }
                                                }) {
                                                    Text(seat)
                                                        .fontWeight(.semibold)
                                                        .frame(width: 40, height: 40)
                                                        .background(selectedSeats.contains(seat) ? themeColor : Color.gray.opacity(0.3))
                                                        .foregroundColor(selectedSeats.contains(seat) ? .white : .black)
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: maxWidth, alignment: .leading)
                        .padding(.horizontal)

                        // Proceed to Payment
                        NavigationLink(destination: PaymentViewE(event: event, date: selectedDate, time: selectedTime, seats: selectedSeats)) {
                            Text("Proceed to Payment")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(themeColor)
                                .cornerRadius(12)
                        }
                        .frame(maxWidth: maxWidth)
                        .padding(.horizontal)

                        // Book Private Theatre
                        NavigationLink(destination: PaymentViewE(event: event, date: selectedDate, time: selectedTime, seats: [])) {
                            Text("Book Private Theatre")
                                .font(.headline)
                                .foregroundColor(themeColor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(themeColor, lineWidth: 2)
                                )
                        }
                        .frame(maxWidth: maxWidth)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
                .background(backgroundColor.ignoresSafeArea())
            }
            .navigationTitle(Text("Booking"))
        }
    }
}

#Preview {
    BookingViewE(event: EventItem(
        imageName: "",
        title: "Meg 2: The Trench",
        genre: "Action, Sci-fi",
        rating: "4.5"
    ))
}
