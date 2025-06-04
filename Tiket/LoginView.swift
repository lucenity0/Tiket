import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {

                    VStack(spacing: 8) {
                        Text("Log In")
                            .font(.system(size: 24, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.size.height * 0.0)

                    Spacer().frame(height: geometry.size.height * 0.05)

                    // Logo and tagline
                    VStack(spacing: 8) {
                        Image("Vector")
                            .resizable()
                            .frame(width: 270, height: 73)

                        Text("Your Screen Your Story")
                            .font(.custom("Rammetto One", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, geometry.size.height * 0.03)

                    // Form Fields
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .font(.system(size: 16, weight: .bold))
                            .kerning(0.08)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                        TextField("Enter your email", text: $email)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .frame(height: 48)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )

                        Text("Password")
                            .font(.system(size: 16, weight: .bold))
                            .kerning(0.08)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                        SecureField("Enter your password", text: $password)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .frame(height: 48)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)

                    // Remember Me and Forgot Password
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.black)

                                Text("Remember me")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                            }
                        }
                        Spacer()
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot password?")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Divider
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .background(Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.3))
                        .padding(.vertical, 10)

                    // Login Button
                    NavigationLink(destination: HomePageView()) {
                        Text("Login")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    }
                    .frame(width: geometry.size.width * 0.9)

                    Spacer().frame(height: 5)

                    // Register link
                    HStack(spacing: 4) {
                        Text("Don’t have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.03, green: 0.03, blue: 0.03))

                        NavigationLink(destination: SignUpView()) {
                            Text("Register Now")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
                                .underline()
                        }
                    }
                    .padding(.top, 16)

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
}

#Preview {
    LoginView()
}
