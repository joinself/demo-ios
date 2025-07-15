//
//  VerifyDocumentStartScreen.swift
//  ios-client
//

import SwiftUI

public struct VerifyDocumentStartScreen: View {
    let onContinue: () -> Void
    let onBack: () -> Void
    
    public init(onContinue: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.onContinue = onContinue
        self.onBack = onBack
    }
    
    public var body: some View {
        FlowStartScreen(headlineIcon: Image("ic_identity", bundle: ResourceHelper.bundle), title: "Identity Verification ", subtitle: "Verify your government-issued identity documents like passport, driver’s license, or national ID. This creates a secure, verifiable credential stored on your device.", cardTitle: "Document Capture Required", cardSubtitle: "You will be asked to capture images of your identity document. Ensure good lighting and that all text is clearly visible.", cardIcon: Image("ic_camera", bundle: ResourceHelper.bundle)) {
            onContinue()
        } onCancel: {
            
        } onBack: {
            onBack()
        }
    }
}

#Preview {
    VerifyDocumentStartScreen {
        
    } onBack: {
        
    }
}
