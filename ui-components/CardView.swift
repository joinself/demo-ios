//
//  CardView.swift
//  ui-components
//
//  Created by Long Pham on 18/6/25.
//

import SwiftUI

public struct CardView: View {
    let icon: String
    let iconImage: Image?
    let iconColor: Color
    let borderColor: Color
    let title: String
    let titleColor: Color
    let description: String
    let descriptionColor: Color
    
    public init(icon: String = "", iconImage: Image? = nil, iconColor: Color = .accentColor, borderColor: Color = .accentColor, title: String,  titleColor: Color = .black, description: String,  descriptionColor: Color = .gray) {
        self.icon = icon
        self.iconImage = iconImage
        self.iconColor = iconColor
        self.borderColor = borderColor
        self.titleColor = titleColor
        self.title = title
        self.description = description
        self.descriptionColor = descriptionColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                if let iconImage = iconImage {
                    iconImage
                } else {
                    Image(systemName: icon)
                        .renderingMode(.template)
                        .foregroundStyle(iconColor)
                        .accentColor(iconColor)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                    
                }
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(titleColor)
                
                Spacer()
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(descriptionColor)
                .lineLimit(nil)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor.opacity(0.3), lineWidth: 1)
                .background(Color.blue.opacity(0.05))
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack {
        CardView(icon: "faceid", iconColor: .red, borderColor: .red, title: "Biometric Verification Required", titleColor: .red, description: "You will be asked to take a selfie to verify your liveness and identity. This process is secure and your biometric data stays on your device.", descriptionColor: .green)
        CardView(icon: "faceid", title: "Biometric Verification Required", description: "You will be asked to take a selfie to verify your liveness and identity. This process is secure and your biometric data stays on your device.")
        CardView(icon: "", title: "Biometric Verification Required", description: "You will be asked to take a selfie to verify your liveness and identity. This process is secure and your biometric data stays on your device.")
    }
}
