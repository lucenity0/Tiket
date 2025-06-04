import SwiftUI

struct OTPView: View {
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var timeRemaining = 60
    @State private var timerActive = true

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    
                    Text("Verify OTP")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.top, geometry.size.height * 0.02)
                    
                    Text("Enter your OTP which has been sent to your email and completely verify your account.")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: geometry.size.width * 0.85, alignment: .leading)
                    
                    HStack(spacing: 15) {
                        ForEach(0..<6, id: \.self) { index in
                            TextField("", text: Binding(
                                get: { otp[index] },
                                set: { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    
                                    if filtered.isEmpty {
                                        otp[index] = ""
                                    } else if otp[index].isEmpty && filtered.count == 1 {
                                        otp[index] = filtered
                                        if index < 5 {
                                            focusedField = index + 1
                                        }
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .frame(width: 40)
                            .multilineTextAlignment(.center)
                            .focused($focusedField, equals: index)
                            .foregroundColor(.black)
                            .background(Color.clear)
                            .overlay(Rectangle().frame(height: 1).padding(.top, 35).foregroundColor(.black))
                            
                            .onChange(of: otp[index]) { newValue in
                                if newValue.isEmpty && index > 0 {
                                    focusedField = index - 1
                                }
                            }
                        }
                    }
                    
                    Text("a code has been sent to your phone")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    if timerActive {
                        Text("Resend OTP in \(timeRemaining)s")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
                    } else {
                        Button("Resend OTP") {
                            timeRemaining = 60
                            timerActive = true
                            startTimer()
                        }
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.32, green: 0.14, blue: 0.14))
                    }
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: HomePageView()) {
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
                        .padding(.horizontal)
                    }
                    
                    Spacer() // pushes the text down
                    
                    Text("Designed for Minimalism, Built by Tiket Team")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.bottom, 10)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(red: 0.9, green: 0.85, blue: 0.81).ignoresSafeArea())
                .onAppear {
                    startTimer()
                    focusedField = 0
                }
            }
        }
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                timerActive = false
            }
        }
    }
}

#Preview {
    OTPView()
}
