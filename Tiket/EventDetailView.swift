import SwiftUI

struct EventDetailView: View {
    let event: EventItem
    
    var body: some View {
        VStack(spacing: 32) {
            // Big centered image with padding & corner radius
            Image(event.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8) // 80% of screen width
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                // Bigger title
                Text(event.title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Bigger genre / description
                Text(event.genre)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Rating with star, slightly bigger
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                Text(event.rating)
                    .font(.title3)
                    .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
            }
            
            Spacer()
            
            // Book Now button
            NavigationLink(destination: BookingViewE(event: event)) {
                Text("Book Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.32, green: 0.14, blue: 0.14))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.96, blue: 0.93), Color(red: 0.93, green: 0.90, blue: 0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
