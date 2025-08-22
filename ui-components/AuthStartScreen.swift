//
//  AuthStartScreen.swift
//  ios-client
//

import SwiftUI

public struct AuthStartScreen: View {
    let onBack: () -> Void
    
    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }
    
    public var body: some View {
        FlowStartScreen(headlineIcon: Image("ic_login", bundle: ResourceHelper.bundle), title: "Authentication Request", subtitle: "The server has requested you authenticate using your biometric credentials. Complete the liveness check to verify your identity.",
                        cardTitle: "Liveness Check Required", cardSubtitle: "You will authenticate to the server using your biometric credentials. Look directly at the camera and follow the on-screen instructions.", cardIcon: Image(systemName: ResourceHelper.ICON_LIVENESS), showButton: false) {
        } onCancel: {
            
        } onBack: {
            onBack()
        }
    }
}



#Preview {
    AuthStartScreen {
        
    }
}
