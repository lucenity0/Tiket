import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    // Add a Published property to indicate if the verification code has been sent
    @Published var isCodeSent = false // New property

    private let db = Firestore.firestore()
    private let auth = Auth.auth() // Keep a reference for convenience

    // This is where we'll store the verification ID temporarily
    private var verificationID: String? // New property

    // Optional: Add an Auth state listener to keep isAuthenticated in sync
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Initialize the listener when the ViewModel is created
        startListeningForAuthState()
    }

    deinit {
        // Clean up the listener when the ViewModel is deallocated
        stopListeningForAuthState()
    }

    // MARK: - Auth State Listener
    private func startListeningForAuthState() {
        authStateDidChangeListenerHandle = auth.addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            // Update isAuthenticated based on whether there's a current user
            DispatchQueue.main.async {
                self.isAuthenticated = user != nil
                // Optional: Clear errorMessage and isCodeSent on sign-in/sign-out
                if user != nil {
                    self.errorMessage = nil
                    self.isCodeSent = false
                }
            }
        }
    }

    private func stopListeningForAuthState() {
        if let handle = authStateDidChangeListenerHandle {
            auth.removeStateDidChangeListener(handle)
            authStateDidChangeListenerHandle = nil
        }
    }


    // MARK: - Sign Up (Existing)
    func signUp(email: String, password: String, name: String, surname: String, completion: @escaping (Bool) -> Void) {
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async { // Ensure UI updates are on main thread
                if let e = error {
                    self.errorMessage = "Authentication Error: \(e.localizedDescription)"
                    self.isAuthenticated = false // Update auth state on failure
                    completion(false)
                } else {
                    guard let user = authResult?.user else {
                        self.errorMessage = "Sign up failed: Could not get user info."
                        self.isAuthenticated = false // Update auth state on failure
                        completion(false)
                        return
                    }

                    let userId = user.uid
                    let username = "\(name) \(surname)".trimmingCharacters(in: .whitespacesAndNewlines)
                    let userEmail = user.email ?? email

                    // ✅ Set displayName on FirebaseAuth user (asynchronous, but doesn't block signup completion)
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { profileError in
                        if let profileError = profileError {
                            print("⚠️ Failed to update profile: \(profileError.localizedDescription)")
                            // You might choose to set errorMessage here, or handle it as a non-critical issue
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

                    self.db.collection("users").document(userId).setData(userData) { firestoreError in
                         DispatchQueue.main.async { // Ensure UI updates are on main thread
                            if let firestoreError = firestoreError {
                                self.errorMessage = "Database Error: \(firestoreError.localizedDescription)"
                                // Decide how to handle this - sign user out?
                                self.isAuthenticated = false // Assuming if Firestore fails, auth isn't complete
                                completion(false)
                            } else {
                                print("✅ Firestore user created for \(userId)")
                                // Both Auth and Firestore creation succeeded (consider async nature of profile update)
                                self.errorMessage = nil // Clear error on success
                                self.isAuthenticated = true // User is now authenticated
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Sign In (Existing)
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        errorMessage = nil // Clear previous errors

        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                    completion(false)
                } else {
                    self.errorMessage = nil
                    // isCodeSent might be true if they switched from phone flow - reset it
                    self.isCodeSent = false
                    // isAuthenticated is updated by the auth state listener
                    completion(true)
                }
            }
        }
    }

    // MARK: - Phone Authentication (New)

    /**
     Requests a verification code for the given phone number.

     - Parameters:
       - phoneNumber: The phone number in E.164 format (e.g., "+16505550101").
       - completion: A closure to be called when the request is complete.
                     It returns `Result<Void, Error>`.
     */
    func requestVerificationCode(for phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        errorMessage = nil // Clear previous errors
        isCodeSent = false // Reset code sent status
        self.verificationID = nil // Clear previous verification ID

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    print("Firebase Phone Auth Error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to send code: \(error.localizedDescription)"
                    self.isCodeSent = false
                    completion(.failure(error))
                } else if let verificationID = verificationID {
                    self.verificationID = verificationID
                    print("Verification ID received.")
                    self.errorMessage = nil
                    self.isCodeSent = true
                    completion(.success(()))
                } else {
                    let fallbackError = NSError(domain: "AuthViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown error. Verification ID not received."])
                    self.errorMessage = fallbackError.localizedDescription
                    completion(.failure(fallbackError))
                }
            }
        }
    }


    /**
     Signs the user in using the received SMS code and the stored verification ID.

     - Parameters:
       - smsCode: The 6-digit code received via SMS.
       - completion: A closure to be called when the sign-in is complete.
                     It returns `Result<Void, Error>`.
     */
    func signInWithSMSCode(_ smsCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        errorMessage = nil // Clear previous errors

        guard let verificationID = self.verificationID else {
            // We don't have a verification ID - maybe the user didn't request a code first?
            // Or maybe the app restarted?
            let error = NSError(domain: "AuthViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Verification ID missing. Please request a new code."])
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
                self.isCodeSent = false // Reset state
                completion(.failure(error))
            }
            return
        }

        // Create a PhoneAuthCredential using the verification ID and SMS code
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )

        // Sign in with the credential
        auth.signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            DispatchQueue.main.async { // Ensure UI updates are on main thread
                if let error = error {
                    print("Firebase Phone Auth Sign In Error: \(error.localizedDescription)")
                    self.errorMessage = "Sign in failed: \(error.localizedDescription)"
                    self.isAuthenticated = false
                    // isCodeSent might remain true if sign-in failed after code was sent
                    completion(.failure(error))
                } else {
                    // Success! User is signed in.
                    print("Phone number signed in successfully.")
                    self.errorMessage = nil // Clear error on success
                    self.isCodeSent = false // Reset state after successful sign-in
                    // isAuthenticated is updated by the auth state listener
                    completion(.success(()))

                    // Optional: Clear the verification ID after successful sign-in
                    self.verificationID = nil
                }
            }
        }
    }

    // MARK: - Existing Auth Methods

    // MARK: - Check Remembered Login (Existing)
    // Note: This method doesn't actually check Firebase Auth state,
    // it only relies on a UserDefaults flag. The auth state listener is
    // a more reliable way to check the current user. You might want
    // to remove or rethink this method.
    func checkIfRemembered() {
        // Consider relying on the authStateDidChangeListenerHandle and Auth.auth().currentUser
        // instead of just UserDefaults for isAuthenticated state.
        // The listener updates `isAuthenticated` when the app starts and Firebase Auth
        // determines the current user from persistence.
        if UserDefaults.standard.bool(forKey: "isRemembered") {
            // If you keep this, make sure it doesn't contradict the listener's state
            // For example, if UserDefaults says remembered, but Firebase says no user (e.g., logged out elsewhere)
             print("Checking remembered login via UserDefaults...")
             // If you keep this, potentially trigger UI update here if needed
             // self.isAuthenticated = UserDefaults.standard.bool(forKey: "isRemembered")
        } else {
            // If UserDefaults says not remembered, ensure isAuthenticated is false (listener should handle this too)
             print("User not remembered via UserDefaults.")
             // If you keep this, potentially trigger UI update here if needed
             // self.isAuthenticated = false
        }
         // A better approach might be to just use the auth state listener to set `isAuthenticated`
         // when the app launches and Firebase determines if a user is already signed in.
    }


    // MARK: - Logout (Existing)
    func logout() {
        errorMessage = nil // Clear previous errors
        do {
            try auth.signOut() // Use the auth instance variable
            // The auth state listener will set isAuthenticated to false
            UserDefaults.standard.set(false, forKey: "isRemembered") // clear remember me flag
            print("User signed out.")
        } catch {
            DispatchQueue.main.async { // Ensure UI updates are on main thread
                self.errorMessage = "Logout failed: \(error.localizedDescription)"
                 // Decide if isAuthenticated should be false even on a failed logout attempt
            }
        }
    }
}
