//
//  RestoreAccountResultScreen.swift
//  ios-client
//

import SwiftUI

public struct RestoreAccountResultScreen: View {
    let success: Bool
    let errorMessage: String
    let onNext: () -> Void
    let onBack: () -> Void
    public init(success: Bool, errorMessage: String = "", onNext: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.success = success
        self.errorMessage = errorMessage
        self.onNext = onNext
        self.onBack = onBack
    }
    public var body: some View {
        ZStack {
            FlowResultScreen(success: success, headline: "Restore Success", subheadline: "Account restore has completed successfully.", headlineFailure: "Restore Failure", subheadlineFailure: "Your account could not be restored. Please try again.", messageSuccess: "Restore Complete", descriptionSuccess: "Your encrypted backup has been restored.",messageFailure: "Restore Failed", descriptionFailure: "Your account restore failed. Error: \(errorMessage)", onContinue: {
                onNext()
            }) {
                onBack()
            }
        }
    }
}

#Preview {
    ScrollView {
        RestoreAccountResultScreen(success: true) {
            
        } onBack: {
            
        }
        
        RestoreAccountResultScreen(success: false) {
            
        } onBack: {
            
        }
    }

}
