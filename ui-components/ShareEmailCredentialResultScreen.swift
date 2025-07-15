//
//  ShareEmailCredentialResultScreen.swift
//  ios-client
//

import SwiftUI

public struct ShareEmailCredentialResultScreen: View {
    let success: Bool
    let errorMessage: String
    let onContinue: () -> Void
    let onBack: (() -> Void)?
    
    public init(success: Bool, errorMessage: String = "", onContinue: @escaping () -> Void, onBack: (() -> Void)? = nil) {
        self.success = success
        self.onContinue = onContinue
        self.errorMessage = errorMessage
        self.onBack = onBack
    }
    
    public var body: some View {
        ShareCredentialBaseResultScreen(success: success, errorMessage: errorMessage, headline: "Sharing Success", subheadline: "You email credential has been shared with the server.", headlineFailure: "Sharing Failure", subheadlineFailure: "Your email credential was not shared with the server. Please try again.", messageSuccess: "Credential Sharing Complete", descriptionSuccess: "Your cryptographic signature has been successfully applied to the document. The signed document has been returned to the server.", messageFailure: "Credential Sharing Failed", descriptionFailure: "Your email credential has not been shared. Error: \(errorMessage)") {
            onContinue()
        } onBack: {
            onBack?()
        }
    }
}

#Preview {
    VStack {
        ShareEmailCredentialResultScreen(
            success: true,
            onContinue: {
                print("Preview: Continue (Success)")
            }
        )
        
        ShareEmailCredentialResultScreen(
            success: false,
            onContinue: {
                print("Preview: Continue (Rejection)")
            }
        )
    }
} 
