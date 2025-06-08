import SwiftUI
import FirebaseAuth // Make sure you have Firebase/Auth imported in your project
import FirebaseFirestore // Make sure you have Firebase/Firestore imported in your project

// You will also need a LoginView struct defined elsewhere in your project
// struct LoginView: View { /* ... */ }

// You will need an AuthViewModel class defined elsewhere in your project
// Ensure it has the updated signUp function as discussed
/*
class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    // ... other properties and functions ...

    func signUp(email: String, password: String, name: String, surname: String, completion: @escaping (Bool) -> Void) {
        // Your Firebase Auth createUser and Firestore setData logic here
        // ...
    }
    // ...
}
*/


struct SignUpView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var emailOrPhone: String = "" // Using for email based on current code flow
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    // StateObject to manage the lifecycle of your ViewModel
    @StateObject private var authVM = AuthViewModel()

    // State variable to control navigation
    @State private var goToLogin = false

    // State variable to show loading indicator
    @State private var isLoading = false

    var body: some View {
        // Use NavigationStack for modern SwiftUI navigation
        NavigationStack {
            GeometryReader { geometry in
                VStack { // Main vertical stack for all content
                    VStack(spacing: 8) {
                        Text("Sign Up")
                            .font(.system(size: 24, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.size.height * 0.0) // Adjust padding based on geometry if needed

                    Spacer().frame(height: geometry.size.height * 0.02)

                    VStack(spacing: 5) {
                        // Assuming "Vector" is your app's logo asset
                        Image("Vector")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Use aspectRatio for better scaling
                            .frame(width: 200, height: 53) // Target size for the image

                        Text("Your Screen Your Story")
                            .font(.custom("Rammetto One", size: 15)) // Make sure this custom font is added to your project
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, geometry.size.height * 0.0) // Adjust padding based on geometry if needed

                    VStack(alignment: .leading, spacing: 7) {
                        // Name Field
                        Text("Name")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        TextField("enter your name", text: $name)
                            .styleField() // Custom styling extension

                         // Surname Field
                         Text("Surname")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                         TextField("enter your surname", text: $surname)
                             .styleField() // Custom styling extension

                        // Email Field
                        Text("Email")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        TextField("enter your email", text: $emailOrPhone)
                            .styleField() // Custom styling extension
                            .keyboardType(.emailAddress) // Hint the keyboard type
                            .autocapitalization(.none) // Emails are typically lowercase
                            .disableAutocorrection(true) // Avoid autocorrect changing email format

                        // Password Field with Toggle
                        Text("Password")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        HStack {
                            if showPassword {
                                TextField("enter your password", text: $password)
                                    .foregroundColor(.black) // Input text color
                            } else {
                                SecureField("enter your password", text: $password)
                                    .foregroundColor(.black) // Input text color
                            }
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .stylePasswordField() // Custom styling extension

                        // Confirm Password Field with Toggle
                        Text("Confirm Password")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        HStack {
                            if showConfirmPassword {
                                TextField("confirm your password", text: $confirmPassword)
                                    .foregroundColor(.black) // Input text color
                            } else {
                                SecureField("confirm your password", text: $confirmPassword)
                                    .foregroundColor(.black) // Input text color
                            }
                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .stylePasswordField() // Custom styling extension
                    }
                    .padding(.horizontal) // Apply horizontal padding to the fields container

                    // Divider line
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8) // Make divider shorter than full width
                        .background(Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.3))
                        .padding(.vertical, 10)

                    // Sign Up Button
                    Button(action: {
                        // --- Basic Input Validation ---
                        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                             authVM.errorMessage = "Please enter your name"
                             return
                        }
                         guard !surname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                             authVM.errorMessage = "Please enter your surname"
                             return
                         }
                        guard !emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                             authVM.errorMessage = "Please enter your email"
                             return
                        }
                        // Simple email format check (can be more robust)
                        guard emailOrPhone.contains("@") && emailOrPhone.contains(".") else {
                             authVM.errorMessage = "Please enter a valid email address"
                             return
                        }
                        guard password.count >= 6 else { // Firebase Auth minimum password length
                             authVM.errorMessage = "Password must be at least 6 characters long"
                             return
                        }
                        guard password == confirmPassword else {
                            authVM.errorMessage = "Passwords do not match"
                            return
                        }
                        // --- End Validation ---


                        // Set loading state and clear previous error
                        isLoading = true
                        authVM.errorMessage = nil

                        // Call the ViewModel's sign-up function
                        authVM.signUp(email: emailOrPhone, password: password, name: name, surname: surname) { success in
                            // Turn off loading regardless of success/failure
                            isLoading = false
                            if success {
                                // If sign-up and Firestore write are successful, trigger navigation
                                goToLogin = true
                            }
                            // If there was an error, the ViewModel's errorMessage property
                            // will be updated, and the Text view below will display it.
                        }
                    }) {
                         // Show spinner or button text based on loading state
                         if isLoading {
                             ProgressView()
                                 .progressViewStyle(CircularProgressViewStyle(tint: .white))
                         } else {
                             Text("Sign Up")
                                 .font(.system(size: 16, weight: .bold))
                         }
                    }
                    .frame(width: geometry.size.width * 0.9) // Button width
                    .padding() // Padding inside the button before background
                    .background(Color(red: 0.32, green: 0.14, blue: 0.14)) // Button background color
                    .foregroundColor(.white) // Button text color
                    .cornerRadius(12) // Rounded corners
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4) // Button shadow
                    .disabled(isLoading) // Disable button while loading to prevent multiple taps

                    // Error message display - listens to changes in authVM.errorMessage
                    if let error = authVM.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width * 0.9) // Match button width for alignment
                    }

                    // NavigationLink to LoginView
                    // This link is invisible (using EmptyView) and is activated
                    // programmatically by the 'isActive' binding to 'goToLogin'.
                    NavigationLink(destination: LoginView(), isActive: $goToLogin) {
                        EmptyView() // The visual label part of the NavigationLink (invisible)
                    }
                    .hidden() // Hide the NavigationLink itself from the UI layout

                    // "Have an account?" text and Login link
                    HStack(spacing: 4) {
                        Text("Have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.black)

                        // Direct NavigationLink for the Login text
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
                                .underline()
                        }
                    }
                    .padding(.top, 16) // Space above this section

                    Spacer() // Pushes content towards the top

                    // Footer text
                    Text("Designed for Minimalism, Built by Tiket Team")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.bottom, 10)

                } // End of Main VStack
                .frame(width: geometry.size.width, height: geometry.size.height) // Make VStack fill the screen
                .background(Color(red: 0.9, green: 0.85, blue: 0.81).ignoresSafeArea()) // Apply background color
            } // End of GeometryReader
        } // End of NavigationStack
    } // End of body
} // End of SignUpView struct

// Styling extensions (keep these as they were)
extension View {
    func styleField() -> some View {
        self
            .foregroundColor(.black) // ✅ fixed input text color
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .frame(height: 48)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
            )
    }

    func stylePasswordField() -> some View {
        self
            .foregroundColor(.black) // ✅ fixed input text color
            .padding(.horizontal, 8) // Less horizontal padding than styleField because of the eye icon
            .frame(height: 48)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
            )
    }
}

// Preview Provider
#Preview {
    SignUpView()
}
