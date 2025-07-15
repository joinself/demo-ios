//
//  AuthResultScreen.swift
//  ios-client
//

import SwiftUI

public struct AuthResultScreen: View {
    @State private var showSuccessToast = true
    let success: Bool
    let onContinue: () -> Void
    
    public init(showSuccessToast: Bool = true, success: Bool, onContinue: @escaping () -> Void) {
        self.showSuccessToast = showSuccessToast
        self.success = success
        self.onContinue = onContinue
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // DEBUG Header
                HStack {
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 40) {
                        // Checkmark Icon and Title Section
                        VStack(spacing: 24) {
                            // Blue Checkmark Circle
                            ZStack {
                                Image(systemName: success ? "checkmark.circle.fill" : "exclamationmark.circle")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.primaryBlue)
                            }
                            .padding(.top, 40)
                            
                            // Title and Subtitle
                            VStack(spacing: 12) {
                                Text(success ? "Authentication Success" : "Authentication Failure")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Text(success ? "Your identity has been verified successfully. Your biometric credentials were validated by the server." : "Your identity could not be verified. Please try again.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // Identity Verified Info Box
                        if success {
                            CardView(icon: "checkmark.circle.fill", iconColor: .green, borderColor: .green, title: "Verification Complete", description: "You will authenticate to the server using your biometric credentials. Look directly at the camera and follow the on-screen instructions.")
                        } else {
                            CardView(icon: "exclamationmark.circle", iconColor: .primaryError, borderColor: .primaryError, title: "Verification Complete", description: "You will authenticate to the server using your biometric credentials. Look directly at the camera and follow the on-screen instructions.")
                        }
                    }
                    .padding(.bottom, 20) // Space above button
                }
                
                // Fixed button at bottom
                Button(action: {
                    onContinue()
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(Color.white)
            }
            .background(Color.white)
            
            // Success Toast Notification
            if showSuccessToast {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                        
                        Text("Authentication response sent!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80) // Position above Continue button
                }
                .onAppear {
                    // Auto-hide success toast after 4 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            showSuccessToast = false
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    VStack {
        AuthResultScreen(showSuccessToast: true, success: true) {
            
        }
        
        AuthResultScreen(showSuccessToast: false, success: false) {
            
        }
    }
}
