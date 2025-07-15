//
//  ShareDocumentCredentialStartScreen.swift
//  ios-client
//

import SwiftUI

public struct ShareDocumentCredentialStartScreen: View {
    let onApprove: () -> Void
    let onDeny: () -> Void
    let onBack: () -> Void
    
    public init(onApprove: @escaping () -> Void, onDeny: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.onApprove = onApprove
        self.onDeny = onDeny
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseStartScreen(headlineIcon: Image("ic_identity", bundle: ResourceHelper.bundle), headline: "Share ID Number?", subheadline: "The server is requesting your verified identity document number.", cardIcon: Image("ic_share", bundle: ResourceHelper.bundle), cardTitle: "Server Request", cardDescription: "The server has requested proof of your identity. Share your verified government-issued identity document number credential to prove your identity.") {
            onApprove()
        } onCancel: {
            onDeny()
        } onBack: {
            onBack()
        }
    }
}

#Preview {
    ShareDocumentCredentialStartScreen {
        
    } onDeny: {
        
    } onBack: {
        
    }

}
