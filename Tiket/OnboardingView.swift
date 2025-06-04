import SwiftUI

struct OnboardingView: View {
    @ScaledMetric var titleSize: CGFloat = 25
    @ScaledMetric var subtitleSize: CGFloat = 15
    @ScaledMetric var buttonSize: CGFloat = 16

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * 0.04) {
                    Spacer()

                    // Title
                    Text("Discover the best movies")
                        .font(.custom("Rammetto One", size: titleSize))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

                    // Subtitle
                    Text("Get started on your immersive Movie ticket booking experience with just a click! Go ahead and click the button below.")
                        .font(.system(size: subtitleSize, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

                    // Navigation Button
                    NavigationLink(destination: LoginSignUpView()) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 18))
                            Text("Get Started")
                                .font(.system(size: buttonSize, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.18, green: 0.07, blue: 0.07))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    }
                    .frame(width: geometry.size.width * 0.9)

                }
                .padding(.horizontal, 24)
                .padding(.vertical, geometry.size.height * 0.08)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    ZStack {
                        Image("onboardingBackground")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()

                        Color.black.opacity(0.7)
                            .ignoresSafeArea()

                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.9, green: 0.85, blue: 0.81).opacity(0.15), location: 0.00),
                                .init(color: Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.7), location: 0.78),
                                .init(color: Color(red: 0.32, green: 0.14, blue: 0.14).opacity(0.4), location: 1.00),
                            ],
                            startPoint: .top,
                            endPoint: UnitPoint(x: 0.5, y: 1.08)
                        )
                        .ignoresSafeArea()
                    }
                )
            }
        }
    }
}

#Preview {
    OnboardingView()
}
