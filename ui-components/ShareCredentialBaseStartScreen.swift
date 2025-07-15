//
//  ShareCredentialBaseStartScreen.swift
//  ios-client
//

import SwiftUI

public struct ShareCredentialBaseStartScreen: View {
    let headlineIcon: Image
    let headline: String
    let subheadline: String
    
    let cardIcon: Image
    let cardTitle: String
    let cardDescription: String
    
    let onOK: () -> Void
    let onCancel: () -> Void
    let onBack: (() -> Void)?
    
    public init(headlineIcon: Image, headline: String, subheadline: String, cardIcon: Image, cardTitle: String, cardDescription: String, onOK: @escaping () -> Void, onCancel: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.headlineIcon = headlineIcon
        self.headline = headline
        self.subheadline = subheadline
        self.cardIcon = cardIcon
        self.cardTitle = cardTitle
        self.cardDescription = cardDescription
        self.onOK = onOK
        self.onCancel = onCancel
        self.onBack = onBack
    }
    
    public var body: some View {
        VStack(spacing: 0) {
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
                    // Shield Icon and Title Section
                    VStack(spacing: 24) {
                        // Shield Icon
                        headlineIcon
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text(headline)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text(subheadline)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Biometric Verification Info Box
                    CardView(iconImage: cardIcon, title: cardTitle, description: cardDescription)
                }
                .padding(.bottom, 20) // Space above button
            }
            
            // Fixed button at bottom
            VStack {
                Button(action: {
                    onOK()
                }) {
                    Text("Approve")
                        .modifier(ButtonOKModifier())
                }
                Button(action: {
                    onCancel()
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
    ShareCredentialBaseStartScreen(headlineIcon: Image("ic_backup", bundle: ResourceHelper.bundle), headline: "Headline", subheadline: "Subheadline", cardIcon: Image("ic_idenity", bundle: ResourceHelper.bundle), cardTitle: "Card title", cardDescription: "Card description") {
        
    } onCancel: {
        
    } onBack: {
        
    }

}
