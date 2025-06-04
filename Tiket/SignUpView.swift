import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var emailOrPhone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {

                    VStack(spacing: 8) {
                        Text("Sign Up")
                            .font(.system(size: 24, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.size.height * 0.0)

                    Spacer().frame(height: geometry.size.height * 0.02)

                    // Logo and tagline
                    VStack(spacing: 5) {
                        Image("Vector")
                            .resizable()
                            .frame(width: 200, height: 53)

                        Text("Your Screen Your Story")
                            .font(.custom("Rammetto One", size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, geometry.size.height * 0.0)

                    // Form Fields
                    VStack(alignment: .leading, spacing: 7) {
                        Group {
                            Text("Name")
                                .font(.system(size: 16, weight: .bold))
                                .kerning(0.08)
                                .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                            TextField("enter your name", text: $name)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 13)
                                .foregroundColor(.black)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                                )

                            Text("Email / Phone Number")
                                .font(.system(size: 16, weight: .bold))
                                .kerning(0.08)
                                .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                            TextField("enter your email or phone", text: $emailOrPhone)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 13)
                                .foregroundColor(.black)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                                )
                        }

                        Group {
                            Text("Password")
                                .font(.system(size: 16, weight: .bold))
                                .kerning(0.08)
                                .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                            HStack {
                                if showPassword {
                                    TextField("enter your password", text: $password)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 13)
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("enter your password", text: $password)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 13)
                                        .foregroundColor(.black)
                                }
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 48)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )

                            Text("Confirm Password")
                                .font(.system(size: 16, weight: .bold))
                                .kerning(0.08)
                                .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))

                            HStack {
                                if showConfirmPassword {
                                    TextField("confirm your password", text: $confirmPassword)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 13)
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("confirm your password", text: $confirmPassword)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 13)
                                        .foregroundColor(.black)
                                }
                                Button(action: {
                                    showConfirmPassword.toggle()
                                }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 48)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)

                    // Divider
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .background(Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.3))
                        .padding(.vertical, 10)

                    // Sign Up Button
                    NavigationLink(destination: LoginView()) {
                        Text("Sign Up")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    }
                    .frame(width: geometry.size.width * 0.9)
                    
                    // login link
                    HStack(spacing: 4) {
                        Text("Have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.03, green: 0.03, blue: 0.03))

                        NavigationLink(destination: LoginView()) {
                            Text("Login")
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
    SignUpView()
}
