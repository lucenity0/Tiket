import SwiftUI

struct LoginSignUpView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * 0.04) {
                    Spacer()

                    // Logo and tagline
                    VStack(spacing: 10) {
                        Image("Vector")
                            .resizable()
                            .frame(width: 300, height: 83)

                        Text("Your Screen Your Story")
                            .font(.custom("Rammetto One", size: 22))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)

                        // Optional secondary tagline
                        Text("Minimalist Ticket Booking App")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.9))
                    }

                    // Add visual/illustration to break space
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .background(Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.3))
                        .padding(.vertical, 10)

                    // Login and Sign Up buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        }

                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.32, green: 0.14, blue: 0.14), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)

                    Spacer()

                    // Footer / hint text
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
    LoginSignUpView()
}
