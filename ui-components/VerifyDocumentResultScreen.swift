//
//  VerifyDocumentResultScreen.swift
//  ios-client
//

import SwiftUI

public struct VerifyDocumentResultScreen: View {
    let success: Bool
    let errorMessage: String
    let onContinue: () -> Void
    let onBack: () -> Void
    
    public init(success: Bool, errorMessage: String = "", onContinue: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.success = success
        self.errorMessage = errorMessage
        self.onContinue = onContinue
        self.onBack = onBack
    }
    
    public var body: some View {
        FlowResultScreen(success: success, headline: "Verification Success", subheadline: "Your identity document has been successfully verified and a secure credential has been created on your device.", headlineFailure: "Verification Failure", subheadlineFailure: "Your identity document could not be verified. Please try again.", messageSuccess: "Verification Complete", descriptionSuccess: "Your document has been authenticated and a verifiable credential has been securely stored on your device. You can now use this credential to prove your identity.", messageFailure: "Verification Failed", descriptionFailure: "Your identity document has not been verified. Error: \(errorMessage)", onContinue: {
            onContinue()
        }) {
            onBack()
        }
    }
}

#Preview {
    ScrollView {
        VerifyDocumentResultScreen(success: true, errorMessage: "error") {
            
        } onBack: {
            
        }
        
        VerifyDocumentResultScreen(success: false, errorMessage: "error") {
            
        } onBack: {
            
        }

    }
    
}
