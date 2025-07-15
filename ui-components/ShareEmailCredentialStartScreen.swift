//
//  ShareEmailCredentialScreen.swift
//  ios-client
//

import SwiftUI

public struct ShareEmailCredentialStartScreen: View {
    let onOK: () -> Void
    let onCancel: () -> Void
    let onBack: (() -> Void)?
    
    public init(onOK: @escaping () -> Void, onCancel: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.onOK = onOK
        self.onCancel = onCancel
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseStartScreen(headlineIcon: Image("ic_email", bundle: ResourceHelper.bundle), headline: "Share Email?", subheadline: "The server is requesting your verified email address.", cardIcon: Image("ic_share", bundle: ResourceHelper.bundle), cardTitle: "Server Request", cardDescription: "The server has requested proof of your email address. Share your verified email address credential to prove ownership of your email address.") {
            onOK()
        } onCancel: {
            onCancel()
        } onBack: {
            onBack?()
        }
    }
}

#Preview {
    ShareEmailCredentialStartScreen(onOK: {
        
    }, onCancel: {
        
    }, onBack: {
        
    })

}
