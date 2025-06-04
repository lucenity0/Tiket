import SwiftUI

struct ForgotPasswordView: View {
    @State private var emailOrPhone: String = ""

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    VStack(spacing: 8) {
                        Text("Forgot Password")
                            .font(.system(size: 24, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.size.height * 0.02)

                    Spacer().frame(height: geometry.size.height * 0.03)

                    // Instruction text
                    Text("Enter the email/phone no associated with your account and we’ll send an email/SMS with code to reset your password")
                        .font(.system(size: 14, weight: .semibold))
                        .opacity(0.6)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: geometry.size.width * 0.85, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.horizontal)

                    // Input field
                    VStack(alignment: .leading, spacing: 16) {
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
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Divider
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .background(Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.3))
                        .padding(.vertical, 10)

                    // Confirm button
                    NavigationLink(destination: OTPView()) {
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
}

#Preview {
    ForgotPasswordView()
}
