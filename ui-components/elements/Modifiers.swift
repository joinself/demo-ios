//
//  Ne.swift
//  Example
//
//  Created by Long Pham on 10/7/25.
//

import SwiftUI


struct ButtonOKModifier: ViewModifier {
    var color: Color = .black
    
    public init(color: Color = .black) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primaryBlue)
            .cornerRadius(12)
    }
}


struct ButtonCancelModifier: ViewModifier {
    var color: Color = .black
    
    public init(color: Color = .black) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color.primaryBlue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.white)
            .cornerRadius(12)
            .overlay(
            RoundedRectangle(cornerRadius: 12)
            .inset(by: 0.5)
            .stroke(Color.primaryBlue, lineWidth: 1)
            )
    }
}

#Preview {
    VStack {
        Button {
            
        } label: {
            Text("OK")
                .modifier(ButtonOKModifier())
        }

        Button {
            
        } label: {
            Text("Cancel")
                .modifier(ButtonCancelModifier())
        }

    }.padding()
}
