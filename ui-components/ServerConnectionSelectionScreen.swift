//
//  ServerConnectionScreen.swift
//  ios-client
//

import SwiftUI

public enum ConnectionActionType {
    case manuallyConnect
    case scanQrCodeConnect
}

public struct ServerConnectionSelectionScreen: View {
    let onActionSelected: (ConnectionActionType) -> Void
    let onBack: (() -> Void)?
    
    public init(onActionSelected: @escaping (ConnectionActionType) -> Void, onBack: ( () -> Void)?) {
        self.onActionSelected = onActionSelected
        self.onBack = onBack
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // DEBUG Header
                HStack {
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 40) {
                    // Cloud Icon and Title Section
                    VStack(spacing: 24) {
                        // Cloud Icon
                        Image(systemName: ResourceHelper.ICON_CLOUD)
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text("Connect to Server")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("Connect to a server using one of the methods below.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Secure Connection Info Box
                    VStack {
                        ActionCardView(
                            icon: "lock",
                            title: "Server Address",
                            description: "Connect to the server using the server address.",
                            action: {
                                onActionSelected(.manuallyConnect)
                            }
                        )
                        
                        ActionCardView(
                            icon: "qrcode",
                            title: "Server QR Code",
                            description: "Scan the servers QR code to connect.",
                            action: {
                                onActionSelected(.scanQrCodeConnect)
                            }
                        )
                    }.padding()
                }
            }
        }
        .background(Color.white)
    }
}

#Preview {
    ServerConnectionSelectionScreen { actionType in
        
    } onBack: {
        
    }

}
