import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import MessageUI

struct Booking: Identifiable {
    var id: String
    var title: String
    var date: Date
    var time: String
    var seats: [String]
    var type: String
}

struct UserView: View {
    @State private var bookings: [Booking] = []

    @State private var userName = ""
    @State private var userEmail = ""
    @State private var profileImageURL: URL?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showHelpSheet = false
    @State private var showLogoutConfirmation = false

    @State private var selectedBooking: Booking?
    @State private var navigateToTicket = false
    @State private var showBookings = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    let db = Firestore.firestore()
    let storage = Storage.storage()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Profile Section
                VStack(spacing: 10) {
                    if let profileImage {
                        profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(Text("Add").foregroundColor(.secondary))
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Change Profile Picture")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }

                    Text(userName)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)

                    Text(userEmail)
                        .foregroundColor(.secondary)
                        .font(.subheadline)

                    if showError {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }

                Divider()

                // MARK: - Show My Tickets
                Button(action: {
                    withAnimation {
                        showBookings.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "ticket.fill")
                            .foregroundColor(.white)
                        Text(showBookings ? "Hide My Tickets" : "Show My Tickets")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: showBookings ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
                }

                if showBookings {
                    if bookings.isEmpty {
                        Text("No tickets found.")
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(bookings) { booking in
                                Button(action: {
                                    selectedBooking = booking
                                    navigateToTicket = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(booking.title)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text("\(booking.date.formatted(date: .abbreviated, time: .shortened))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text("Seats: \(booking.seats.isEmpty ? "Private Theatre" : booking.seats.joined(separator: ", "))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .slide))
                    }
                }

                Divider()

                // MARK: - Account Items
                VStack(spacing: 16) {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            Text("Personal Information")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                    }

                    accountRow(title: "Language", systemIcon: "globe", trailingText: "English (US)", action: {})
                    accountRow(title: "Setting", systemIcon: "gear", action: {})
                }

                Divider()

                // MARK: - Help Center & Logout
                VStack(spacing: 16) {
                    accountRow(title: "Help Center", systemIcon: "info.circle") {
                        showHelpSheet.toggle()
                    }

                    Button {
                        showLogoutConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .foregroundColor(.red)
                            Text("Log Out")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .confirmationDialog("Are you sure you want to log out?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                        Button("Log Out", role: .destructive) {
                            logout()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }

                NavigationLink(
                    destination: ticketDestination(for: selectedBooking),
                    isActive: $navigateToTicket
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .onAppear(perform: loadUserData)
        .onChange(of: selectedPhoto) { _ in uploadProfilePhoto() }
        .sheet(isPresented: $showHelpSheet) {
            HelpSheet()
        }
    }

    func accountRow(title: String, systemIcon: String, trailingText: String? = nil, action: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: systemIcon)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            if let trailing = trailingText {
                Text(trailing)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.05), radius: 2, x: 0, y: 1)
        .onTapGesture {
            action()
        }
    }

    func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            print("❌ No logged-in user")
            return
        }

        print("👤 Logged in user UID: \(user.uid)")

        let docRef = db.collection("users").document(user.uid)
        docRef.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.userName = data["username"] as? String ?? "N/A"
                self.userEmail = data["email"] as? String ?? "N/A"

                if let urlStr = data["profileImageUrl"] as? String,
                   let url = URL(string: urlStr) {
                    profileImageURL = url
                    loadImage(from: url)
                }

                // Fetch bookings using current UID
                fetchBookings(for: user.uid)
            } else {
                showError = true
                errorMessage = "Failed to load user data"
            }
        }
    }


    func fetchBookings(for uid: String) {
        db.collection("bookings")
            .whereField("userId", isEqualTo: uid)
            .order(by: "timestamp", descending: true) // important: descending = true

            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Firestore error: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No booking documents found")
                    return
                }

                self.bookings = documents.compactMap { doc in
                    let data = doc.data()
                    return Booking(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                        time: data["time"] as? String ?? "",
                        seats: data["seats"] as? [String] ?? [],
                        type: data["type"] as? String ?? ""
                    )
                }
            }
    }

    func uploadProfilePhoto() {
        guard let item = selectedPhoto else { return }

        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let user = Auth.auth().currentUser {

                    let storageRef = storage.reference().child("profileImages/\(user.uid).jpg")
                    _ = try await storageRef.putDataAsync(data)
                    let url = try await storageRef.downloadURL()

                    try await db.collection("users").document(user.uid).updateData([
                        "profileImageUrl": url.absoluteString
                    ])

                    profileImageURL = url
                    profileImage = Image(uiImage: image)
                    selectedPhoto = nil
                    showError = false
                } else {
                    showError = true
                    errorMessage = "Invalid image format."
                }
            } catch {
                showError = true
                errorMessage = "Failed to upload image: \(error.localizedDescription)"
            }
        }
    }

    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }

    @ViewBuilder
    func ticketDestination(for booking: Booking?) -> some View {
        if let booking = booking {
            switch booking.type {
            case "event":
                TicketDetailViewE(
                    event: EventItem(imageName: "", title: booking.title, genre: "", rating: ""),
                    date: booking.date,
                    time: booking.time,
                    seats: booking.seats
                )
            case "movie":
                TicketDetailViewM(
                    movie: MovieItem(
                        imageName: "",
                        title: booking.title,
                        genre: "",
                        rating: "",
                        duration: "N/A",
                        description: nil,
                        cast: nil,
                        review: nil
                    ),
                    date: booking.date,
                    time: booking.time,
                    seats: booking.seats
                )
            case "sport":
                TicketDetailViewS(
                    sport: SportItem(imageName: "", title: booking.title, genre: "", rating: ""),
                    date: booking.date,
                    time: booking.time,
                    seats: booking.seats
                )
            default:
                Text("Unsupported booking type")
            }
        } else {
            Text("No booking selected")
        }
    }

    func logout() {
        authViewModel.logout()
    }
}

#Preview {
    NavigationView {
        UserView()
            .environmentObject(AuthViewModel())
    }
}
