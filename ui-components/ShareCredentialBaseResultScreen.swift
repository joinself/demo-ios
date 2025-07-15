//
//  ShareCredentialBaseResultScreen.swift
//  ios-client
//

import SwiftUI

public struct ShareCredentialBaseResultScreen: View {
    let success: Bool
    let errorMessage: String
    let headline: String
    let subheadline: String
    let headlineFailure: String
    let subheadlineFailure: String
    
    let messageSuccess: String
    let descriptionSuccess: String
    let messageFailure: String
    let descriptionFailure: String
    
    let onContinue: () -> Void
    let onBack: () -> Void
    
    public init(success: Bool, errorMessage: String, headline: String, subheadline: String, headlineFailure: String, subheadlineFailure: String, messageSuccess: String, descriptionSuccess: String, messageFailure: String, descriptionFailure: String, onContinue: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.success = success
        self.errorMessage = errorMessage
        self.headline = headline
        self.subheadline = subheadline
        self.headlineFailure = headlineFailure
        self.subheadlineFailure = subheadlineFailure
        self.messageSuccess = messageSuccess
        self.descriptionSuccess = descriptionSuccess
        self.messageFailure = messageFailure
        self.descriptionFailure = descriptionFailure
        self.onContinue = onContinue
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            FlowResultScreen(success: success, headline: headline, subheadline: subheadline, headlineFailure: headlineFailure, subheadlineFailure: subheadlineFailure, messageSuccess: messageSuccess, descriptionSuccess: descriptionSuccess ,messageFailure: messageFailure, descriptionFailure: descriptionFailure, onContinue: {
                onContinue()
            }) {
                onBack()
            }
        }
    }
}


#Preview {
    ScrollView {
        ShareCredentialBaseResultScreen(success: true, errorMessage: "", headline: "Headline", subheadline: "Subheadline", headlineFailure: "headlineFailure", subheadlineFailure: "subheadlineFailure", messageSuccess: "messageSuccess", descriptionSuccess: "descriptionSuccess", messageFailure: "messageFailure", descriptionFailure: "descriptionFailure") {
            
        } onBack: {
            
        }
        
        ShareCredentialBaseResultScreen(success: false, errorMessage: "", headline: "Headline", subheadline: "Subheadline", headlineFailure: "headlineFailure", subheadlineFailure: "subheadlineFailure", messageSuccess: "messageSuccess", descriptionSuccess: "descriptionSuccess", messageFailure: "messageFailure", descriptionFailure: "descriptionFailure") {
            
        } onBack: {
            
        }

    }
}
