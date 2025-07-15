//
//  DocSignResultScreen.swift
//  ios-client
//

import SwiftUI

public struct DocSignResultScreen: View {
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
        ShareCredentialBaseResultScreen(success: success, errorMessage: errorMessage, headline: "Signing Success", subheadline: "Your digital signature has been added to the document.", headlineFailure: "Signing Failure", subheadlineFailure: "Your digital signature has not been added to the document. Please try again.", messageSuccess: "Document Signing Complete", descriptionSuccess: "Your cryptographic signature has been successfully applied to the document. The signed document has been returned to the server.", messageFailure: "Document Signing Failed", descriptionFailure: "Your signature has not been applied to the document. Error: \(errorMessage)") {
            onContinue()
        } onBack: {
            onBack?()
        }
    }
}

#Preview {
    ScrollView {
        DocSignResultScreen(
            success: true,
            onContinue: {
                print("Preview: Continue (Success)")
            }
        )
        
        DocSignResultScreen(
            success: false,
            onContinue: {
                print("Preview: Continue (Rejection)")
            }
        )
    }
} 
