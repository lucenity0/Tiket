import SwiftUI
import CoreImage.CIFilterBuiltins

struct TicketDetailViewM: View {
    let movie: MovieItem
    let date: Date
    let time: String
    let seats: [String]
    let cinema = "PVR iMAX"
    
    @State private var navigateToHome = false

    var body: some View {
        VStack(spacing: 24) {
            // Navigation Title
            Text("Ticket Details")
                .font(.title2)
                .bold()

            // Checkmark and Message
            VStack(spacing: 12) {
                Circle()
                    .fill(Color(red: 0.32, green: 0.14, blue: 0.14))
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold)))

                Text("Tickets Booked Successfully!")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
            }

            // Ticket Card
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    Image(movie.imageName)
                        .resizable()
                        .frame(width: 80, height: 110)
                        .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.title)
                            .font(.headline)

                        HStack {
                            Label("16+", systemImage: "shield.fill")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)

                            Text("ENG")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)

                            Text("SUB/ENGLISH")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }

                        Text(movie.genre)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(movie.duration ?? "N/A")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Divider()

                Group {
                    HStack {
                        Text("CINEMA")
                        Spacer()
                        Text(cinema)
                            .bold()
                    }

                    HStack {
                        Text("DATE")
                        Spacer()
                        Text(formattedDate(date))
                            .bold()
                    }

                    HStack {
                        Text("TIME")
                        Spacer()
                        Text(time)
                            .bold()
                    }

                    HStack {
                        Text("SEATS")
                        Spacer()
                        Text(seats.joined(separator: ", "))
                            .bold()
                    }
                }
                .font(.subheadline)

                Divider()

                BarcodeView(dataString: "\(seats.joined()).tiket.\(movie.title.replacingOccurrences(of: " ", with: ""))")
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

            // Confirm button with NavigationLink to HomePageView
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
                    .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .background(Color(red: 0.94, green: 0.89, blue: 0.85).ignoresSafeArea())
        .navigationTitle("")                       // Hide navigation title text
        .navigationBarTitleDisplayMode(.inline)   // Use inline mode for smoothness
        .navigationBarBackButtonHidden(true)      // Hide default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigateToHome = true       // Custom back button triggers same nav as confirm
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
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

struct BarcodeView: View {
    let dataString: String
    let context = CIContext()
    let filter = CIFilter.code128BarcodeGenerator()

    var body: some View {
        if let barcodeImage = generateBarcode(from: dataString) {
            Image(uiImage: barcodeImage)
                .interpolation(.none) // sharp edges
                .resizable()
                .scaledToFit()
                .frame(height: 60)
        } else {
            Text("Invalid Barcode")
        }
    }

    func generateBarcode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.message = data

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 3, y: 3))
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
