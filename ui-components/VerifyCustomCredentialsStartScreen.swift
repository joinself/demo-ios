//
//  VerifyCustomCredentialsStartScreen.swift
//  ios-client
//

import SwiftUI

public struct VerifyCustomCredentialsStartScreen: View {
    let onContinue: () -> Void
    let onBack: () -> Void
    
    public init(onContinue: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.onContinue = onContinue
        self.onBack = onBack
    }
    
    public var body: some View {
        FlowStartScreen(headlineIcon: Image("ic_custom_fact", bundle: ResourceHelper.bundle), title: "Get Custom Credential ", subtitle: "A new custom credential will be delivered to your device.", cardTitle: "Credential Generation", cardSubtitle: "The server will generate and securely sign a new custom credential for you, then deliver it to your device.", cardIcon: Image("ic_settings", bundle: ResourceHelper.bundle)) {
            onContinue()
        } onCancel: {
            
        } onBack: {
            onBack()
        }
    }
}

#Preview {
    VerifyCustomCredentialsStartScreen {
        
    } onBack: {
        
    }
}
