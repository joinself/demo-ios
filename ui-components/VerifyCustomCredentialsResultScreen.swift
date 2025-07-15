//
//  VerifyCustomCredentialsResultScreen.swift
//  ios-client
//

import SwiftUI

public struct VerifyCustomCredentialsResultScreen: View {
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
        FlowResultScreen(success: success, headline: "Get Credential Success", subheadline: "Your credential has been received from the server and stored on your device.", headlineFailure: "Get Credential Failure", subheadlineFailure: "Your credential has not been delivered. Please try again.", messageSuccess: "Credential Delivered", descriptionSuccess: "Your custom credential has been generated and signed by the server, and securely stored on your device. You can now use this credential to prove your information about yourself.", messageFailure: "Credential Not Delivered", descriptionFailure: "You did not receive your custom credential from the server. Error: \(errorMessage)", onContinue: {
            onContinue()
        }) {
            onBack()
        }
    }
}

#Preview {
    ScrollView {
        VerifyCustomCredentialsResultScreen(success: true) {
            
        } onBack: {
            
        }
        
        VerifyCustomCredentialsResultScreen(success: false) {
            
        } onBack: {
            
        }
    }
    
}
