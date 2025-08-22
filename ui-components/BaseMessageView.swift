//
//  BaseMessageView.swift
//  Example
//
//  Created by Long Pham on 19/8/25.
//
import SwiftUI

public struct BaseMessageView<Content: View>: View {
    let content: Content
    public init(
        @ViewBuilder content: () -> Content) {
            self.content = content()
        }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 12) {
            VStack {
                content
            }
        }
        
    }
}

#Preview {
    BaseMessageView {
        AuthStartScreen {
            
        }
    }
}
