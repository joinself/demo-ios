//
//  BackupAccountStartScreen.swift
//  ios-client
//

import SwiftUI

public struct BackupAccountResultScreen: View {
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
            FlowResultScreen(success: success, headline: "Backup Success", subheadline: "Account backup has completed successfully.", headlineFailure: "Backup Failure", subheadlineFailure: "Your account could not be backed up. Please try again.", messageSuccess: "Backup Complete", descriptionSuccess: "Your data has been backed up in an encrypted file. You can restore the data using your biometrics.",messageFailure: "Backup Failed", descriptionFailure: "Your account backup failed. Error:  \(errorMessage)", onContinue: {
                onNext()
            }) {
                onBack()
            }
        }
    }
}

#Preview {
    ScrollView {
        BackupAccountResultScreen(success: true, onNext: {}, onBack: {})
        BackupAccountResultScreen(success: false, onNext: {}, onBack: {})
    }
}
