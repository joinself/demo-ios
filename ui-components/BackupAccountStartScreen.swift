//
//  BackupAccountStartScreen.swift
//  ios-client
//

import SwiftUI

public struct BackupAccountStartScreen: View {
    @Binding private var isProcessing: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    public init(isProcessing: Binding<Bool> = .constant(false), onNext: @escaping () -> Void, onBack: @escaping () -> Void) {
        self._isProcessing = isProcessing
        self.onNext = onNext
        self.onBack = onBack
    }
    
    public var body: some View {
        ZStack {
            FlowStartScreen(headlineIcon: Image("ic_cloud_up", bundle: ResourceHelper.bundle), title: "Account Backup", subtitle: "Securely backup your account.", cardTitle: "Encrypted Backup", cardSubtitle: "Your account data will be encrypted and backed up. You can restore it using your biometrics.", cardIcon: Image("ic_encrypted", bundle: ResourceHelper.bundle)) {
                onNext()
            } onCancel: {
                
            } onBack: {
                onBack()
            }
        }
    }
}

#Preview {
    VStack {
        BackupAccountStartScreen {
            
        } onBack: {
            
        }
    }
}
