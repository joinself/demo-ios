//
//  VerifyEmailResultScreen.swift
//  ios-client
//

import SwiftUI

public struct VerifyEmailResultScreen: View {
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
        FlowResultScreen(success: success, headline: "Verification Success", subheadline: "Your email address has been successfully verified and a secure credential has been created on your device.", headlineFailure: "Verification Failure", subheadlineFailure: "Your email address could not be verified. Please try again.", messageSuccess: "Verification Complete", descriptionSuccess: "Your email address has been verified and a secure credential has been created on your device.",messageFailure: "Verification Failed", descriptionFailure: "Your email has not been verified. Error: \(errorMessage)", onContinue: {
            onContinue()
        }) {
            onBack()
        }
    }
}

#Preview {
    ScrollView {
        VerifyEmailResultScreen(success: true) {
            
        } onBack: {
            
        }
        
        VerifyEmailResultScreen(success: false) {
            
        } onBack: {
            
        }
    }
}
