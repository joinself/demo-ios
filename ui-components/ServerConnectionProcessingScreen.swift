//
//  ServerConnectionProcessingScreen.swift
//  ios-client
//

import SwiftUI

public struct ServerConnectionProcessingScreen: View {
    @State private var currentStep = 1
    @Binding var isConnecting: Bool
    @Binding var connectionError: String?
    @Binding var hasTimedOut:Bool
    
    let serverAddress: String
    let onConnectionComplete: () -> Void
    let onConnectionStart: (String) -> Void
    let onGoBack: () -> Void
    
    public init(currentStep: Int = 1, isConnecting: Binding<Bool> = .constant(true), connectionError: Binding<String?> = .constant(nil), hasTimedOut: Binding<Bool> = .constant(false), serverAddress: String,
                onConnectionStart: @escaping (String) -> Void,
                onConnectionComplete: @escaping () -> Void,  onGoBack: @escaping () -> Void) {
        self.currentStep = currentStep
        self._isConnecting = isConnecting
        self._connectionError = connectionError
        self._hasTimedOut = hasTimedOut
        self.serverAddress = serverAddress
        self.onConnectionComplete = onConnectionComplete
        self.onConnectionStart = onConnectionStart
        self.onGoBack = onGoBack
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
                    // Icon and Title Section
                    VStack(spacing: 24) {
                        // Icon - either connecting or error state
                        if hasTimedOut || connectionError != nil {
                            // Error State - Blue circle with exclamation mark
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 40)
                        } else {
                            // Connecting State - Cloud Sync Icon
                            ZStack {
                                Image(systemName: "cloud")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                                
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                                    .offset(x: 15, y: -10)
                            }
                            .padding(.top, 40)
                        }
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text(hasTimedOut || connectionError != nil ? "Connection Timed Out" : "Connecting to Server")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text(hasTimedOut || connectionError != nil ? 
                                 "The connection attempt took too long. Please check your network and try again." :
                                 "Establishing secure connection with the authentication server. Please wait...")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Server Address Info Box
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "cloud.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            Text("Server Address")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        
                        Text("Connecting to: \(serverAddress.prefix(16))...")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            .background(Color.blue.opacity(0.05))
                    )
                    .padding(.horizontal, 20)
                    
                    // Connection Process Section (only show when connecting)
                    if !hasTimedOut && connectionError == nil {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Text("Connection Process")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            VStack(spacing: 20) {
                                ConnectionStepView(
                                    stepNumber: 1,
                                    title: "Contacting Server",
                                    description: "Reaching out to the specified server address",
                                    isActive: currentStep >= 1,
                                    isCompleted: currentStep > 1
                                )
                                
                                ConnectionStepView(
                                    stepNumber: 2,
                                    title: "Secure Handshake",
                                    description: "Establishing encrypted connection and verifying server identity",
                                    isActive: currentStep >= 2,
                                    isCompleted: currentStep > 2
                                )
                                
                                ConnectionStepView(
                                    stepNumber: 3,
                                    title: "Account Registration",
                                    description: "Registering your Self account with the server",
                                    isActive: currentStep >= 3,
                                    isCompleted: currentStep > 3
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Error State Content
                    if hasTimedOut || connectionError != nil {
                        VStack(spacing: 24) {
                            // Connection Failed Error Box
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 20))
                                        .foregroundColor(.red)
                                    
                                    Text("Connection Failed")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                
                                Text("The connection could not be established. This might be due to an incorrect server address, network issues, or server unavailability.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .lineLimit(nil)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    .background(Color.red.opacity(0.05))
                            )
                            .padding(.horizontal, 20)
                            
                            // Troubleshooting Section
                            VStack(alignment: .leading, spacing: 24) {
                                HStack {
                                    Text("Troubleshooting")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                
                                VStack(spacing: 16) {
                                    TroubleshootingStepView(
                                        stepNumber: 1,
                                        title: "Verify Address",
                                        description: "Double-check the 66-character server address is correct"
                                    )
                                    
                                    TroubleshootingStepView(
                                        stepNumber: 2,
                                        title: "Check Network",
                                        description: "Ensure you have a stable internet connection"
                                    )
                                    
                                    TroubleshootingStepView(
                                        stepNumber: 3,
                                        title: "Server Status",
                                        description: "The server might be temporarily unavailable"
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Try Again Button
                            Button(action: {
                                onGoBack()
                            }) {
                                Text("Connection Timed Out - Try Again")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(Color.white)
        .onAppear {
            startServerConnection()
        }
    }
    
    private func startServerConnection() {
        print("🌐 ServerConnectionProcessing: Starting connection to \(serverAddress)")
        
//        guard let account = account else {
//            connectionError = "No account available for server connection"
//            return
//        }
        
        // Start 10-second timeout timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            if isConnecting {
                print("🌐 ServerConnectionProcessing: ⏰ Connection timed out after 10 seconds")
                hasTimedOut = true
                isConnecting = false
            }
        }
        
        // Step 1: Contacting Server
        currentStep = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !isConnecting { return } // Exit if already timed out
            
            // Step 2: Secure Handshake
            currentStep = 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if !isConnecting { return } // Exit if already timed out
                
                // Step 3: Account Registration
                currentStep = 3
                
                onConnectionStart(serverAddress)
                // Actually connect to server using Self SDK
//                Task {
//                    await connectToSelfServer(account: account, serverAddress: serverAddress)
//                }
            }
        }
    }
    
    private func connectToSelfServer(serverAddress: String) async {
        print("🌐 ServerConnectionProcessing: Connecting to Self server with address: \(serverAddress)")
        
        // Check if we already timed out
        if !isConnecting {
            print("🌐 ServerConnectionProcessing: Connection attempt cancelled due to timeout")
            return
        }
        
//        do {
//            let connectionResult = try await account.connectWith(address: serverAddress, info: [:])
//            
//            DispatchQueue.main.async {
//                // Only proceed if we haven't timed out
//                if isConnecting {
//                    print("🌐 ServerConnectionProcessing: ✅ Successfully connected to server")
//                    print("🌐 ServerConnectionProcessing: Connection result: \(connectionResult)")
//                    
//                    currentStep = 4 // Completed
//                    isConnecting = false
//                    
//                    // Wait a moment to show completion, then navigate
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        onConnectionComplete()
//                    }
//                }
//            }
//            
//        } catch {
//            print("🌐 ServerConnectionProcessing: ❌ Failed to connect to server: \(error)")
//            
//            DispatchQueue.main.async {
//                // Only set error if we haven't already timed out
//                if isConnecting {
//                    connectionError = "Failed to connect: \(error.localizedDescription)"
//                    isConnecting = false
//                }
//            }
//        }
    }
}

struct ConnectionStepView: View {
    let stepNumber: Int
    let title: String
    let description: String
    let isActive: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Step Number Circle
            ZStack {
                Circle()
                    .fill(isActive ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Text("\(stepNumber)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            
            // Step Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(nil)
            }
            
            Spacer()
            
            // Progress indicator for active step
            if isActive && !isCompleted {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }
}

struct TroubleshootingStepView: View {
    let stepNumber: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Step Number Circle
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                
                Text("\(stepNumber)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Step Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ServerConnectionProcessingScreen(
        serverAddress: "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef12",
        onConnectionStart: { serverAddress in
            
        }, onConnectionComplete: {
            print("Preview: Connection complete")
        }, onGoBack: {
            print("Preview: Go back")
        }
    )
} 
