//
//  ActionSelectionScreen.swift
//  ios-client
//

import SwiftUI

public enum ActionType {
    case authenticate
    case verifyCredentials
    case provideCredentials
    case signDocuments
    case backup
}

public struct ActionSelectionScreen: View {
    @State private var showSuccessToast: Bool
    
    let onActionSelected: (ActionType) -> Void
    let onBack: (() -> Void)?
    
    public init(showConnectionSuccess: Bool = false, onActionSelected: @escaping (ActionType) -> Void, onBack: (() -> Void)? = nil) {
        self.onActionSelected = onActionSelected
        self._showSuccessToast = State(initialValue: showConnectionSuccess)
        self.onBack = onBack
    }
    
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    // DEBUG Header
                    HStack {
                        Button {
                            onBack?()
                        } label: {
                            Image(systemName: ResourceHelper.ICON_BACK)
                                .foregroundStyle(Color.blue)
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
                                Text("Server Connected")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Text("Your Self account is connected to the server and ready to use. Choose an action below to get started.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // Available Actions Section
                        VStack(alignment: .leading, spacing: 24) {
                            
                            VStack(spacing: 16) {
                                ActionCardView(
                                    iconImage: Image("ic_fingerprint", bundle: ResourceHelper.bundle),
                                    title: "Authenticate",
                                    description: "Use your biometric credentials to securely log in to services",
                                    action: {
                                        onActionSelected(.authenticate)
                                    }
                                )
                                
                                ActionCardView(
                                    icon: "lock.shield.fill",
                                    title: "Verify Credentials",
                                    description: "Verify information about you such as email and government-issued ID.",
                                    action: {
                                        onActionSelected(.verifyCredentials)
                                    }
                                )
                                
                                ActionCardView(
                                    iconImage: Image("ic_share", bundle: ResourceHelper.bundle),
                                    title: "Share Credentials",
                                    description: "Securely share verified information about you",
                                    action: {
                                        onActionSelected(.provideCredentials)
                                    }
                                )
                                
                                ActionCardView(
                                    iconImage: Image("edit_document", bundle: ResourceHelper.bundle),
                                    title: "Digital Signatures",
                                    description: "Sign a document with your digital signature.",
                                    action: {
                                        onActionSelected(.signDocuments)
                                    }
                                )
                                
                                ActionCardView(
                                    iconImage: Image("ic_backup", bundle: ResourceHelper.bundle),
                                    title: "Backup",
                                    description: "Create an encrypted backup of your account data",
                                    action: {
                                        onActionSelected(.backup)
                                    }
                                )
                            }
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
    ActionSelectionScreen(
        showConnectionSuccess: false,
        onActionSelected: { actionType in
            print("Preview: Selected action: \(actionType)")
        }
    )
} 
