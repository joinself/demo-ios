//
//  ShareCredentialResultScreen.swift
//  ios-client
//

import SwiftUI

public struct ShareCredentialResultScreen: View {
    let success: Bool
    let errorMessage: String
    let onContinue: () -> Void
    let onBack: (() -> Void)?
    
    public init(success: Bool, errorMessage: String = "", onContinue: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.success = success
        self.errorMessage = errorMessage
        self.onContinue = onContinue
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseResultScreen(success: success, errorMessage: errorMessage, headline: "Sharing Success", subheadline: "You custom credential has been shared with the server.", headlineFailure: "Sharing Failure", subheadlineFailure: "Your custom credential was not shared with the server. Please try again.", messageSuccess: "Credential Sharing Complete", descriptionSuccess: "You have provided your verified custom credential to the server.", messageFailure: "Credential Sharing Failed", descriptionFailure: "Your custom credential has not been shared. Error: \(errorMessage)") {
            onContinue()
        } onBack: {
            onBack?()
        }
    }
}

#Preview {
    ScrollView {
        ShareCredentialResultScreen(success: true) {
            
        }
        
        ShareCredentialResultScreen(success: true) {
            
        }
    }
} 
