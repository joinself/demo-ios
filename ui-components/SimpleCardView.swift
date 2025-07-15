//
//  SimpleCardView.swift
//  ui-components
//
//  Created by Long Pham on 18/6/25.
//

import SwiftUI

public struct SimpleCardView: View {
    
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let action: () -> Void
    @State private var isPressed = false
    
    public init(icon: String, iconColor: Color = .accentColor, title: String, description: String, action: @escaping () -> Void, isPressed: Bool = false) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.description = description
        self.action = action
        self.isPressed = isPressed
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .renderingMode(.template)
                .foregroundStyle(iconColor)
                .accentColor(iconColor)
                .font(.system(size: 20))
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SimpleCardView(icon: "shield",
                   title: "Authenticate",
                   description: "Use your biometric credentials to securely log in to services",
                   action: {
                   }
    )
}
