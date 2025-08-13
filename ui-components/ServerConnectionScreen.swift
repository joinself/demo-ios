//
//  ServerConnectionScreen.swift
//  ios-client
//

import SwiftUI

public struct ServerConnectionScreen: View {
    @State private var serverAddress = ""
    @State private var showSuccessMessage = true // Show the success message from registration
    @State private var isConnecting = false
    
    let onConnectToServer: (String) -> Void
    let onBack: (() -> Void)?
    
    private let maxCharacters = 66
    
    private var isValidServerAddress: Bool {
        return serverAddress.count == maxCharacters && serverAddress.allSatisfy { $0.isHexDigit }
    }
    
    public init(serverAddress: String = "", showSuccessMessage: Bool = true, isConnecting: Bool = false, onConnectToServer: @escaping (String) -> Void, onBack: (() -> Void)? = nil) {
        self.serverAddress = serverAddress
        self.showSuccessMessage = showSuccessMessage
        self.isConnecting = isConnecting
        self.onConnectToServer = onConnectToServer
        self.onBack = onBack
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // DEBUG Header
                HStack {
                    Button {
                        onBack?()
                    } label: {
                        Image(systemName: ResourceHelper.ICON_BACK)
                            .foregroundStyle(Color.primaryBlue)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 40) {
                    // Cloud Icon and Title Section
                    VStack(spacing: 24) {
                        // Cloud Icon
                        Image("private_connectivity", bundle: ResourceHelper.bundle)
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text("Connect by Address")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("Enter the server address/identifier to connect to the server.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    CardView(icon: "lock.shield.fill", title: "Secure Connection", description: "Your connection will be encrypted and all communications with the server will be secure.")
                    
                    // Server Address Section
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Enter the 66-character hexadecimal server address/ID.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Enter 66-char hex address", text: $serverAddress)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .font(.system(size: 16))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: serverAddress) { newValue in
                                    // Limit to 66 characters and ensure hex
                                    let filtered = newValue.filter { $0.isHexDigit }
                                    if filtered.count > maxCharacters {
                                        serverAddress = String(filtered.prefix(maxCharacters))
                                    } else {
                                        serverAddress = filtered
                                    }
                                }
                            
                            HStack {
                                Text("\(serverAddress.count)/\(maxCharacters) characters")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 60)
                    
                    // Connect to Server Button
                    Button(action: {
                        connectToServer()
                    }) {
                        HStack {
                            if isConnecting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: isValidServerAddress ? .white : .black))
                                    .scaleEffect(0.8)
                                Text("Connecting...")
                            } else {
                                Text("Connect")
                            }
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isValidServerAddress ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isValidServerAddress ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .disabled(!isValidServerAddress || isConnecting)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                
                // Success Message (shown after registration)
                if showSuccessMessage {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                            
                            Text("Account registered successfully!")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .onAppear {
                        // Auto-hide success message after 4 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showSuccessMessage = false
                            }
                        }
                    }
                }
            }
            Spacer(minLength: 80)
        }
        .background(Color.white)
    }
    
    private func connectToServer() {
        guard isValidServerAddress else {
            return
        }
        
        print("🌐 ServerConnectionScreen: Navigating to server connection processing with address: \(serverAddress)")
        
        // Navigate to the processing screen
        onConnectToServer(serverAddress)
    }
}

#Preview {
    ServerConnectionScreen(
        onConnectToServer: { serverAddress in
            print("Preview: Connect to server: \(serverAddress)")
        }
    )
}

extension Character {
    var isHexDigit: Bool {
        return self.isASCII && (self.isNumber || ("a"..."f").contains(self.lowercased().first!) || ("A"..."F").contains(self))
    }
} 
