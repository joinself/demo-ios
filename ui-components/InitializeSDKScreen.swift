//
//  InitializeSDKScreen.swift
//  ios-client
//

import SwiftUI

public struct InitializeSDKScreen: View {
    @StateObject private var sdkExample = SelfSDKInitializationExample()
    @State private var currentStep = 0
    @State private var isInitializing = true
    @Binding var isInitialized: Bool
    let onInitializationComplete: () -> Void
    public init(currentStep: Int = 0, isInitializing: Bool = true, isInitialized: Binding<Bool>, onInitializationComplete: @escaping () -> Void) {
        self.currentStep = currentStep
        self.isInitializing = isInitializing
        self._isInitialized = isInitialized
        self.onInitializationComplete = onInitializationComplete
    }
    
    // Computed properties to simplify complex expressions
    
    private var statusColor: Color {
        if sdkExample.isInitialized {
            return .green
        } else if sdkExample.errorMessage != nil {
            return .red
        } else {
            return .gray
        }
    }
    
    private var borderColor: Color {
        if sdkExample.isInitialized {
            return Color.green.opacity(0.3)
        } else if sdkExample.errorMessage != nil {
            return Color.red.opacity(0.3)
        } else {
            return Color.blue.opacity(0.3)
        }
    }
    
    private var backgroundColor: Color {
        if sdkExample.isInitialized {
            return Color.green.opacity(0.05)
        } else if sdkExample.errorMessage != nil {
            return Color.red.opacity(0.05)
        } else {
            return Color.blue.opacity(0.05)
        }
    }
    
    private var step1Description: String {
        return sdkExample.isLoading ? "Initializing..." : "Initializing cryptographic libraries and security modules"
    }
    
    private var step3Description: String {
        return sdkExample.isInitialized ? "✅ Connected to Self network" : "Connecting to Self network and configuring environment"
    }
    
    private var step3IsActive: Bool {
        return currentStep >= 3 || isInitialized
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
                
                VStack(spacing: 32) {
                    // Cloud Icon
                    VStack(spacing: 24) {
                        Image(systemName: "arrow.clockwise.icloud")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text("Initializing Self SDK")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("Setting up your Self environment. This may take a few moments on first launch.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Initialization Steps Section
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Initialization Steps")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack(spacing: 20) {
                            InitializationStepView(
                                stepNumber: 1,
                                title: "Loading SDK Components",
                                description: step1Description,
                                isActive: currentStep >= 1
                            )
                            
                            InitializationStepView(
                                stepNumber: 2,
                                title: "Setting Up Storage",
                                description: "Creating secure storage for your account credentials",
                                isActive: currentStep >= 2
                            )
                            
                            InitializationStepView(
                                stepNumber: 3,
                                title: "Establishing Environment",
                                description: step3Description,
                                isActive: step3IsActive
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Self SDK Status Box
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.2.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            Text("Self SDK")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            if sdkExample.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else if isInitialized {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                            } else if sdkExample.errorMessage != nil {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                            }
                        }
                        
                        Text(sdkExample.statusMessage)
                            .font(.system(size: 14))
                            .foregroundColor(statusColor)
                            .lineLimit(nil)
                        
                        if let error = sdkExample.errorMessage {
                            Text("Error: \(error)")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 1)
                            .background(backgroundColor)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(Color.white)
        .onAppear {
            startInitialization()
        }
        .onChange(of: isInitialized) { isInitialized in
            if isInitialized {
                currentStep = 3
                isInitializing = false
                
                // Wait a moment to show the success state, then navigate
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    if let account = sdkExample.getAccount() {
                        onInitializationComplete()
//                    }
                }
            }
        }
        .onChange(of: sdkExample.isLoading) { isLoading in
            if isLoading {
                currentStep = 1
            }
        }
    }
    
    private func startInitialization() {
        // Actually initialize the Self SDK
        print("🚀 InitializeSDKScreen: Starting real Self SDK initialization...")
        
        // Step 1: Start SDK initialization
        currentStep = 1
        
        // Call the real SDK initialization
        sdkExample.initializeSDK()
        
        // Update UI steps as we progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            currentStep = 2
//            isInitialized = true
        }
        
        
    }
}

struct InitializationStepView: View {
    let stepNumber: Int
    let title: String
    let description: String
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Step Number Circle
            ZStack {
                Circle()
                    .fill(isActive ? Color.blue : Color.gray.opacity(0.3))
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
    @State var isInitialized = false
    InitializeSDKScreen(isInitialized: $isInitialized) {
        
    }
    .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isInitialized = true
        }
    }
//    InitializeSDKScreen(onInitializationComplete: { account in
//        print("Preview: SDK initialization complete with account")
//    })
} 
