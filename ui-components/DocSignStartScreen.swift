//
//  DocSignStartScreen.swift
//  ios-client
//

import SwiftUI

public struct DocSignStartScreen: View {
    let onBack: (() -> Void)?
    
    public init(onBack: (() -> Void)? = nil) {
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseStartScreen(headlineIcon: Image("ic_pdf", bundle: ResourceHelper.bundle), headline: "Document Signing", subheadline: "The server is requesting you sign the PDF document.", cardIcon: Image("ic_idenity", bundle: ResourceHelper.bundle), cardTitle: "Server Request", cardDescription: "You are being asked to sign a PDF document. This creates a verifiable digital signature using your cryptographic credentials.") {
            
        } onCancel: {
            
        } onBack: {
            onBack?()
        }
    }
}

#Preview {
    DocSignStartScreen
    {
        
    }
}
