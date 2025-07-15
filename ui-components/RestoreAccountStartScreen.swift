//
//  RestoreAccountStartScreen.swift
//  ios-client
//

import SwiftUI

public struct RestoreAccountStartScreen: View {
    @Binding private var isProcessing: Bool
    @State private var errorMessage: String? = nil
    let onNext: () -> Void
    let onBack: () -> Void
    public init(isProcessing: Binding<Bool> = .constant(false), errorMessage: String? = nil, onNext: @escaping () -> Void, onBack: @escaping () -> Void) {
        self._isProcessing = isProcessing
        self.errorMessage = errorMessage
        self.onNext = onNext
        self.onBack = onBack
    }
    
    public var body: some View {
        ZStack {
            FlowStartScreen(headlineIcon: Image("ic_cloud_up", bundle: ResourceHelper.bundle), title: "Account Restore", subtitle: "Restore your account from backup.", cardTitle: "Biometric Restore", cardSubtitle: "Your backup data is encrypted. To restore it you will need to complete a liveness check.", cardIcon: Image("ic_encrypted", bundle: ResourceHelper.bundle)) {
                onNext()
            } onCancel: {
                
            } onBack: {
                onBack()
            }
        }
    }
}

#Preview {
    RestoreAccountStartScreen(onNext: {
            
        }) {
            // restore
        }
}
