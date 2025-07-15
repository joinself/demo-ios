//
//  DocSignStartScreen.swift
//  ios-client
//

import SwiftUI

public struct DocSignStartScreen: View {
    let onSignDocument: () -> Void
    let onRejectDocument: () -> Void
    let onBack: (() -> Void)?
    
    public init(onSignDocument: @escaping () -> Void, onRejectDocument: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.onSignDocument = onSignDocument
        self.onRejectDocument = onRejectDocument
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseStartScreen(headlineIcon: Image("ic_pdf", bundle: ResourceHelper.bundle), headline: "Document Signing", subheadline: "The server is requesting you sign the PDF document.", cardIcon: Image("ic_idenity", bundle: ResourceHelper.bundle), cardTitle: "Server Request", cardDescription: "You are being asked to sign a PDF document. This creates a verifiable digital signature using your cryptographic credentials.") {
            onSignDocument()
        } onCancel: {
            onRejectDocument()
        } onBack: {
            onBack?()
        }
    }
}

#Preview {
    DocSignStartScreen(
        onSignDocument: {
            print("Preview: Sign Document")
        },
        onRejectDocument: {
            print("Preview: Reject Document")
        }
    )
} 
