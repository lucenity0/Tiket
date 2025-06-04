//
//  BookingView.swift
//  Tiket
//
//  Created by Nafees S on 05/06/25.
//

import SwiftUI

struct BookingViewE: View {
    let event: EventItem

    @State private var selectedDate = Date()
    @State private var selectedTime = "7:00 PM"
    @State private var selectedSeats: [String] = []

    let availableTimes = ["4:00 PM", "7:00 PM", "9:30 PM"]
    let seatRows = ["A", "B", "C", "D", "E"]
    let seatNumbers = [1, 2, 3, 4, 5, 6, 7, 8]

    // Color theme consistent with your app
    let themeColor = Color(red: 0.32, green: 0.14, blue: 0.14)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Date Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(Color(red: 0.98, green: 0.96, blue: 0.93))
                    .cornerRadius(12)
                    .padding(.horizontal)

                // Time Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Time")
                        .font(.headline)
                        .foregroundColor(themeColor)
                        .padding(.horizontal)

                    HStack {
                        ForEach(availableTimes, id: \.self) { time in
                            Button(action: {
                                selectedTime = time
                            }) {
                                Text(time)
                                    .fontWeight(.medium)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(selectedTime == time ? themeColor : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedTime == time ? .white : themeColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Seat Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Seats")
                        .font(.headline)
                        .foregroundColor(themeColor)
                        .padding(.horizontal)

                    ForEach(seatRows, id: \.self) { row in
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
                        .padding(.horizontal)
                    }
                }

                // Proceed to Payment button
                NavigationLink(destination: PaymentViewE(event: event, date: selectedDate, time: selectedTime, seats: selectedSeats)) {
                    Text("Proceed to Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // Book Private Theatre button
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
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(red: 0.94, green: 0.89, blue: 0.85).ignoresSafeArea())
        .navigationTitle("Booking")
    }
}
#Preview {
    NavigationStack {
        BookingViewE(event: EventItem(
            imageName: "",
            title: "Meg 2: The Trench",
            genre: "Action, Sci-fi",
            rating: "4.5"
        ))
    }
}
