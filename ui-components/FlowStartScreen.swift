//
//  FlowStartScreen.swift
//  ios-client
//

import SwiftUI

public struct FlowStartScreen: View {
    let headlineIcon: Image
    let title: String
    let subtitle: String
    let cardTitle: String
    let cardSubtitle: String
    let cardIcon: Image
    let onOK: () -> Void
    let onCancel: () -> Void
    let onBack: (() -> Void)?
    let showButton: Bool
    
    public init(headlineIcon: Image, title: String, subtitle: String, cardTitle: String, cardSubtitle: String, cardIcon: Image, showButton: Bool = true, onOK: @escaping () -> Void, onCancel: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.headlineIcon = headlineIcon
        self.title = title
        self.subtitle = subtitle
        self.cardTitle = cardTitle
        self.cardSubtitle = cardSubtitle
        self.cardIcon = cardIcon
        self.showButton = showButton
        self.onOK = onOK
        self.onCancel = onCancel
        self.onBack = onBack
    }
    
    public var body: some View {
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
                    // Shield Icon and Title Section
                    VStack(spacing: 24) {
                        // Shield Icon
                        headlineIcon
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text(title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text(subtitle)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Biometric Verification Info Box
                    CardView(iconImage: cardIcon, title: cardTitle, description: cardSubtitle)
                }
                .padding(.bottom, 20) // Space above button
            }
            
            // Fixed button at bottom
            VStack {
                if showButton {
                    Button(action: {
                        onOK()
                    }) {
                        Text("Start")
                            .modifier(ButtonOKModifier())
                    }
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
    VStack {
        FlowStartScreen(headlineIcon: Image("private_connectivity", bundle: ResourceHelper.bundle), title: "Title", subtitle: "Subtitle", cardTitle: "Card Title", cardSubtitle: "Card description", cardIcon: Image(systemName: "faceid"), showButton: false) {
            
        } onCancel: {
            
        }


    }
}
