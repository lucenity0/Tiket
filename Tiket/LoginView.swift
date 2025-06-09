import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email: String = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = UserDefaults.standard.bool(forKey: "isRemembered")

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    // Title
                    Text("Log In")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, geometry.size.height * 0.05)

                    Spacer().frame(height: geometry.size.height * 0.05)

                    // Logo + Tagline
                    VStack(spacing: 8) {
                        Image("Vector")
                            .resizable()
                            .frame(width: 270, height: 73)
                        Text("Your Screen Your Story")
                            .font(.custom("Rammetto One", size: 18))
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, geometry.size.height * 0.03)

                    // Email & Password Fields
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        TextField("Enter your email", text: $email)
                            .foregroundColor(.black) // ✅ Force black text
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(13)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )

                        Text("Password")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)

                        SecureField("Enter your password", text: $password)
                            .foregroundColor(.black) // ✅ Force black text
                            .padding(13)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)

                    // Remember Me & Forgot Password
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                            UserDefaults.standard.set(rememberMe, forKey: "isRemembered")
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.black)
                                Text("Remember me")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                            }
                        }

                        Spacer()

                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot password?")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .background(Color.black.opacity(0.3))
                        .padding(.vertical, 10)
                    
                    

                    // Login Button
                    Button(action: {
                        authVM.signIn(email: email, password: password) { success in
                            if success {
                                if rememberMe {
                                    UserDefaults.standard.set(true, forKey: "isRemembered")
                                    UserDefaults.standard.set(email, forKey: "savedEmail")
                                } else {
                                    UserDefaults.standard.removeObject(forKey: "isRemembered")
                                    UserDefaults.standard.removeObject(forKey: "savedEmail")
                                }
                            }
                        }
                    }) {
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

                    // Error Message
                    if let error = authVM.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width * 0.9)
                    }

                    Spacer().frame(height: 5)

                    // Register Link
                    HStack(spacing: 4) {
                        Text("Don’t have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        NavigationLink(destination: SignUpView()) {
                            Text("Register Now")
                                .font(.system(size: 14, weight: .semibold))
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
                .background(Color(red: 0.9, green: 0.85, blue: 0.81).ignoresSafeArea())
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
