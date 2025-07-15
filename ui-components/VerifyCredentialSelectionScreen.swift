//
//  VerifyCredentialSelectionScreen.swift
//  ios-client
//

import SwiftUI

public struct VerifyCredentialSelectionScreen: View {
    @State private var showSuccessToast: Bool
    
    let onActionSelected: (CredentialActionType) -> Void
    let onBack: () -> Void
    
    public init(showConnectionSuccess: Bool = false, onActionSelected: @escaping (CredentialActionType) -> Void, onBack: @escaping () -> Void) {
        self.onActionSelected = onActionSelected
        self.onBack = onBack
        self._showSuccessToast = State(initialValue: showConnectionSuccess)
    }
    
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    // DEBUG Header
                    HStack {
                        Button {
                            onBack()
                        } label: {
                            Image(systemName: ResourceHelper.ICON_BACK)
                                .foregroundStyle(Color.primaryBlue)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 40) {
                        // Shield Icon and Title Section
                        VStack(spacing: 24) {
                            // Shield with Checkmark Icon
                            ZStack {
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 40)
                            
                            // Title and Subtitle
                            VStack(spacing: 12) {
                                Text("Get Credentials")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Text("Choose the credential you want to get. These credentials help you establish trust and prove aspects of your identity.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // Available Actions Section
                        VStack(spacing: 16) {
                            ActionCardView(
                                icon: "envelope",
                                title: "Verify Email Address",
                                description: "Verify ownership of your email address",
                                action: {
                                    onActionSelected(.emailAddress)
                                }
                            )
                            
                            ActionCardView(
                                icon: "person.text.rectangle",
                                title: "Verify Identity Document",
                                description: "Verify your goverment-issued identity documents",
                                action: {
                                    onActionSelected(.identityDocument)
                                }
                            )
                            
                            ActionCardView(
                                icon: "person.crop.rectangle.stack.fill",
                                title: "Get Custom Credential",
                                description: "Get credentials that created and verified by your server",
                                action: {
                                    onActionSelected(.customCredential)
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100) // Extra space for toast
                    }
                }
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
                        
                        Text("Connected to server successfully!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
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
    VerifyCredentialSelectionScreen(
        showConnectionSuccess: false,
        onActionSelected: { actionType in
            print("Preview: Selected action: \(actionType)")
        }, onBack: {
            
        }
    )
} 
