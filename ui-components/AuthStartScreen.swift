//
//  AuthStartScreen.swift
//  ios-client
//

import SwiftUI

public struct AuthStartScreen: View {
    let onStartAuthentication: () -> Void
    let onRejectAuthentication: () -> Void
    
    public init(onStartAuthentication: @escaping () -> Void, onRejectAuthentication: @escaping () -> Void) {
        self.onStartAuthentication = onStartAuthentication
        self.onRejectAuthentication = onRejectAuthentication
    }
    
    public var body: some View {
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
                    // Shield Icon and Title Section
                    VStack(spacing: 24) {
                        // Shield Icon
                        Image("ic_login", bundle: ResourceHelper.bundle)
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text("Authentication Request")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("The server has requested you authenticate using your biometric credentials. Complete the liveness check to verify your identity.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Biometric Verification Info Box
                    CardView(icon: ResourceHelper.ICON_LIVENESS, title: "Liveness Check Required", description: "You will authenticate to the server using your biometric credentials. Look directly at the camera and follow the on-screen instructions.")
                }
                .padding(.bottom, 20) // Space above button
            }
            
            // Fixed button at bottom
            VStack {
                Button(action: {
                    onStartAuthentication()
                }) {
                    Text("Approve")
                        .modifier(ButtonOKModifier())
                }
                Button(action: {
                    onRejectAuthentication()
                }) {
                    Text("Reject")
                        .modifier(ButtonCancelModifier())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(Color.white)
        }
        .background(Color.white)
    }
}



#Preview {
    AuthStartScreen(
        onStartAuthentication: {
            print("Preview: Start Authentication")
        }, onRejectAuthentication: {
            
        }
    )
} 
