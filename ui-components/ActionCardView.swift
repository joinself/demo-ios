//
//  ActionCardView.swift
//  Example
//
//  Created by Long Pham on 18/6/25.
//

import SwiftUI

public struct ActionCardView: View {
    let icon: String
    let iconImage: Image?
    let title: String
    let description: String
    let action: () -> Void
    @State private var isPressed = false
    
    public init(icon: String = "", iconImage: Image? = nil, title: String, description: String, action: @escaping () -> Void, isPressed: Bool = false) {
        self.icon = icon
        self.iconImage = iconImage
        self.title = title
        self.description = description
        self.action = action
        self.isPressed = isPressed
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                if let iconImage = iconImage {
                    iconImage
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                        .frame(width: 40, height: 40)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(
                        color: Color.black.opacity(0.08),
                        radius: 8,
                        x: 0,
                        y: 2
                    )
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    VStack {
        ActionCardView(
            icon: "shield",
            title: "Authenticate",
            description: "Use your biometric credentials to securely log in to services",
            action: {
            }
        )
        
        ActionCardView(
            icon: "",
            iconImage: Image("private_connectivity", bundle: ResourceHelper.bundle),
            title: "Authenticate",
            description: "Use your biometric credentials to securely log in to services",
            action: {
            }
        )
    }
}
