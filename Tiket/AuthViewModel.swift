import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    private let db = Firestore.firestore()

    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String, surname: String, completion: @escaping (Bool) -> Void) {
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.errorMessage = "Authentication Error: \(e.localizedDescription)"
                completion(false)
            } else {
                guard let user = authResult?.user else {
                    self.errorMessage = "Sign up failed: Could not get user info."
                    completion(false)
                    return
                }

                let userId = user.uid
                let username = "\(name) \(surname)".trimmingCharacters(in: .whitespacesAndNewlines)
                let userEmail = user.email ?? email

                // ✅ Set displayName on FirebaseAuth user
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { profileError in
                    if let profileError = profileError {
                        print("⚠️ Failed to update profile: \(profileError.localizedDescription)")
                    } else {
                        print("✅ Firebase Auth displayName updated to \(username)")
                    }
                }

                // ✅ Save in Firestore
                let userData: [String: Any] = [
                    "username": username,
                    "email": userEmail,
                    "createdAt": Timestamp()
                ]

                self.db.collection("users").document(userId).setData(userData) { error in
                    if let firestoreError = error {
                        self.errorMessage = "Database Error: \(firestoreError.localizedDescription)"
                        completion(false)
                    } else {
                        print("✅ Firestore user created for \(userId)")
                        completion(true)
                    }
                }
            }
        }
    }

    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                    completion(false)
                } else {
                    self.errorMessage = nil
                    self.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }

    // MARK: - Check Remembered Login
    func checkIfRemembered() {
        if UserDefaults.standard.bool(forKey: "isRemembered") {
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            UserDefaults.standard.set(false, forKey: "isRemembered") // clear remember me flag
        } catch {
            self.errorMessage = "Logout failed: \(error.localizedDescription)"
        }
    }

}
