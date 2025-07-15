//
//  ShareCredentialStartScreen.swift
//  ios-client
//

import SwiftUI

// share custom fact
public struct ShareCredentialStartScreen: View {
    let onApprove: () -> Void
    let onDeny: () -> Void
    let onBack: () -> Void
    
    public init(onApprove: @escaping () -> Void, onDeny: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.onApprove = onApprove
        self.onDeny = onDeny
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseStartScreen(headlineIcon: Image("ic_custom_fact", bundle: ResourceHelper.bundle), headline: "Share Custom Credential?", subheadline: "The server is requesting your custom credential.", cardIcon: Image("ic_share", bundle: ResourceHelper.bundle), cardTitle: "Server Request", cardDescription: "The server has requested proof of your custom credential. Share your verified custom credential.") {
            onApprove()
        } onCancel: {
            onDeny()
        } onBack: {
            onBack()
        }
    }
}

#Preview {
    ShareCredentialStartScreen {
        
    } onDeny: {
        
    } onBack: {
        
    }

}
