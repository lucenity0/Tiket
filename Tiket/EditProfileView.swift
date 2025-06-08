import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditProfileView: View {
    @State private var newUsername = ""
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    let db = Firestore.firestore()

    var body: some View {
        Form {
            Section(header: Text("Change Username")) {
                TextField("New Username", text: $newUsername)
            }

            Section(header: Text("Change Email")) {
                TextField("New Email", text: $newEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }

            Section(header: Text("Change Password")) {
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm Password", text: $confirmPassword)
            }

            Button("Update Profile") {
                updateProfile()
            }
            .disabled(allFieldsEmpty)

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
        }
        .navigationTitle("Edit Profile")
        .alert("Success", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your profile has been updated.")
        }
        .onAppear {
            loadCurrentUserData()
        }
    }

    var allFieldsEmpty: Bool {
        newUsername.isEmpty && newEmail.isEmpty && newPassword.isEmpty
    }

    func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        showError = false
        errorMessage = ""

        // Update username in Firestore
        if !newUsername.isEmpty {
            db.collection("users").document(user.uid).updateData([
                "username": newUsername
            ]) { error in
                if let error = error {
                    showError = true
                    errorMessage = "Username update failed: \(error.localizedDescription)"
                }
            }
        }

        // Update email in Auth and Firestore
        if !newEmail.isEmpty {
            user.updateEmail(to: newEmail) { error in
                if let error = error {
                    showError = true
                    errorMessage = "Email update failed: \(error.localizedDescription)"
                } else {
                    db.collection("users").document(user.uid).updateData([
                        "email": newEmail
                    ])
                }
            }
        }

        // Update password in Auth
        if !newPassword.isEmpty {
            guard newPassword == confirmPassword else {
                showError = true
                errorMessage = "Passwords do not match."
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    showError = true
                    errorMessage = "Password update failed: \(error.localizedDescription)"
                }
            }
        }

        if !showError {
            showSuccess = true
            newUsername = ""
            newEmail = ""
            newPassword = ""
            confirmPassword = ""
        }
    }

    func loadCurrentUserData() {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.newUsername = data["username"] as? String ?? ""
                self.newEmail = data["email"] as? String ?? ""
            }
        }
    }
}
