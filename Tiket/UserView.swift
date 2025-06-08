import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import MessageUI

struct UserView: View {
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var profileImageURL: URL?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showHelpSheet = false
    @State private var showLogoutConfirmation = false

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

                    // Show error if upload fails
                    if showError {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }

                Divider()

                // MARK: - Account Items
                VStack(spacing: 16) {
                    accountRow(title: "Personal Information", systemIcon: "person", action: {})
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

    // MARK: - Account Row Component
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

    // MARK: - Load User Data
    func loadUserData() {
        guard let user = Auth.auth().currentUser else { return }
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
            } else {
                showError = true
                errorMessage = "Failed to load user data"
            }
        }
    }

    // MARK: - Upload Profile Image
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

    // MARK: - Load Image for Display
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }

    // MARK: - Logout
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
