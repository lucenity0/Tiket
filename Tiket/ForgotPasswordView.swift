import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var statusMessage: String? = nil
    @State private var isError: Bool = false
    @FocusState private var isEmailFieldFocused: Bool

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Text("Forgot Password")
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top, geometry.size.height * 0.02)

                    Spacer().frame(height: geometry.size.height * 0.03)

                    Text("Enter the email associated with your account and we’ll send an email with a link to reset your password.")
                        .font(.system(size: 14, weight: .semibold))
                        .opacity(0.6)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: geometry.size.width * 0.85, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    // Input field
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Email")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                        TextField("enter your email", text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .frame(height: 48)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )
                            .focused($isEmailFieldFocused)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Error or Success Message
                    if let message = statusMessage {
                        Text(message)
                            .font(.footnote)
                            .foregroundColor(isError ? .red : .green)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width * 0.9)
                            .padding(.top, 4)
                    }

                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .background(Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.3))
                        .padding(.vertical, 10)

                    // Confirm button
                    Button(action: {
                        isEmailFieldFocused = false
                        sendResetEmail()
                    }) {
                        Text("Confirm")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    }
                    .frame(width: geometry.size.width * 0.9)

                    Spacer()

                    Text("Designed for Minimalism, Built by Tiket Team")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.bottom, 10)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    Color(red: 0.9, green: 0.85, blue: 0.81)
                        .ignoresSafeArea()
                )
            }
        }
    }

    // MARK: - Firebase Password Reset Logic
    private func sendResetEmail() {
        guard !email.isEmpty else {
            statusMessage = "Please enter your email."
            isError = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                statusMessage = error.localizedDescription
                isError = true
            } else {
                statusMessage = "A password reset link has been sent to your email."
                isError = false
            }
        }
    }
}
