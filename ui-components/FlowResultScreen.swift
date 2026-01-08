//
//  FlowResultScreen.swift
//  ios-client
//

import SwiftUI

public struct FlowResultScreen: View {
    @State private var showSuccessToast = true
    let success: Bool
    
    let headline: String
    let subheadline: String
    let headlineFailure: String
    let subheadlineFailure: String
    
    let messageSuccess: String
    let descriptionSuccess: String
    let messageFailure: String
    let descriptionFailure: String
    let onContinue: () -> Void
    let onBack: (() -> Void)?
    
    public init(showSuccessToast: Bool = false, success: Bool, headline: String, subheadline: String, headlineFailure: String = "Verification Failure", subheadlineFailure: String = "Verification Failure description", messageSuccess: String, descriptionSuccess: String, messageFailure: String, descriptionFailure: String, onContinue: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.showSuccessToast = showSuccessToast
        self.success = success
        self.headline = headline
        self.subheadline = subheadline
        self.headlineFailure = headlineFailure
        self.subheadlineFailure = subheadlineFailure
        self.messageSuccess = messageSuccess
        self.descriptionSuccess = descriptionSuccess
        self.messageFailure = messageFailure
        self.descriptionFailure = descriptionFailure
        self.onContinue = onContinue
        self.onBack = onBack
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // DEBUG Header
                HStack {
                    Button {
                        onBack?()
                    } label: {
                        Image(systemName: ResourceHelper.ICON_BACK)
                            .foregroundStyle(Color.primaryBlue)
                    }
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
                                Text(success ? headline : headlineFailure)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Text(success ? subheadline : subheadlineFailure)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // Identity Verified Info Box
                        if success {
                            CardView(icon: "checkmark.circle.fill", iconColor: .green, borderColor: .green, title: messageSuccess, description: descriptionSuccess)
                        } else {
                            CardView(icon: "exclamationmark.circle", iconColor: .primaryError, borderColor: .primaryError, title: messageFailure, description: descriptionFailure)
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
        }
    }
}



#Preview {
    ScrollView {
        FlowResultScreen(success: true, headline: "Headline", subheadline: "Subheadline", messageSuccess: "messageSuccess", descriptionSuccess: "descriptionSuccess", messageFailure: "messageFailure", descriptionFailure: "messageFailure", onContinue: {
            
        })
        
        FlowResultScreen(success: false, headline: "Headline", subheadline: "Subheadline", messageSuccess: "messageSuccess", descriptionSuccess: "descriptionSuccess", messageFailure: "messageFailure", descriptionFailure: "messageFailure", onContinue: {

        })
    }
}
