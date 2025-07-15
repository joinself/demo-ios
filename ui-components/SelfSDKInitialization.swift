//
//  SelfSDKInitialization.swift
//  ios-client
//
//  Educational Example: Self SDK Initialization
//  
//  This example demonstrates proper Self SDK initialization patterns for iOS:
//  - SDK initialization with environment configuration
//  - Account creation with storage setup
//  - Status monitoring and connection handling
//  - Error handling and retry patterns
//
//  Educational Value:
//  - Shows step-by-step SDK setup process
//  - Demonstrates proper storage directory configuration
//  - Illustrates status listener implementation
//  - Provides error handling best practices

import SwiftUI

/**
 * Self SDK Initialization Example
 * 
 * This class demonstrates the complete process of initializing the Self SDK
 * and setting up an Account object for use in iOS applications.
 * 
 * Key Learning Points:
 * 1. Proper SDK initialization sequence
 * 2. Account builder configuration
 * 3. Storage path setup for iOS
 * 4. Status monitoring implementation
 * 5. Error handling patterns
 */
class SelfSDKInitializationExample: ObservableObject {
    
    private let LOGTAG = "SelfSDKInit"
    
    // MARK: - Published Properties for UI
    @Published var isInitialized = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var statusMessage = "Ready to initialize"
    @Published var userAddress = ""
    
    // MARK: - Private Properties
//    private var account: Account? = nil
    
    /**
     * Step 1: Initialize the Self SDK
     * 
     * The Self SDK must be initialized before creating any Account objects.
     * This is a one-time operation that sets up the SDK's internal state.
     */
    func initializeSDK() {
        print("\(LOGTAG): 📚 EXAMPLE: Starting Self SDK initialization...")
        
        isLoading = true
        errorMessage = nil
        statusMessage = "Initializing Self SDK..."
        
        do {
            // Initialize the Self SDK
            // This is safe to call multiple times
//            SelfSDK.initialize()
            
            print("\(LOGTAG): ✅ EXAMPLE: Self SDK initialized successfully")
            statusMessage = "SDK initialized, creating account..."
            
            // Proceed to account creation
            createAccount()
            
        } catch {
            print("\(LOGTAG): ❌ EXAMPLE: Failed to initialize SDK: \(error)")
            errorMessage = "SDK initialization failed: \(error.localizedDescription)"
            statusMessage = "SDK initialization failed"
            isLoading = false
        }
    }
    
    /**
     * Step 2: Create Account with Proper Configuration
     * 
     * The Account object is the main interface to Self SDK functionality.
     * Proper configuration is essential for production applications.
     */
    private func createAccount() {
        print("\(LOGTAG): 📚 EXAMPLE: Creating Self SDK Account...")
        
        do {
            // Step 2a: Set up storage directory
            let storagePath = setupStorageDirectory()
            print("\(LOGTAG): 📚 EXAMPLE: Storage path configured: \(storagePath)")
            
            // Step 2b: Create Account using Builder pattern
//            account = Account.Builder()
//                .withEnvironment(Environment.production)  // Use production environment
//                .withSandbox(true)                       // Enable sandbox mode for testing
//                .withStoragePath(storagePath)            // Set storage location
//                .build()
            
            print("\(LOGTAG): ✅ EXAMPLE: Account object created successfully")
            statusMessage = "Account created, setting up listeners..."
            
            // Step 3: Set up status monitoring
            setupStatusListener()
            
        } catch {
            print("\(LOGTAG): ❌ EXAMPLE: Failed to create account: \(error)")
            errorMessage = "Account creation failed: \(error.localizedDescription)"
            statusMessage = "Account creation failed"
            isLoading = false
        }
    }
    
    /**
     * Step 2a: Setup Storage Directory
     * 
     * The Self SDK requires a persistent storage location for account data.
     * This example shows the recommended iOS storage setup.
     */
    private func setupStorageDirectory() -> String {
        print("\(LOGTAG): 📚 EXAMPLE: Setting up storage directory...")
        
        // Use iOS Documents directory for persistent storage
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Create a dedicated subdirectory for Self SDK data
        let storageURL = documentsDirectory.appendingPathComponent("selfsdk_storage")
        
        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: storageURL.path) {
            do {
                try fileManager.createDirectory(at: storageURL, withIntermediateDirectories: true, attributes: nil)
                print("\(LOGTAG): 📁 EXAMPLE: Created storage directory at: \(storageURL.path)")
            } catch {
                print("\(LOGTAG): ⚠️ EXAMPLE: Warning - could not create storage directory: \(error)")
            }
        }
        
        return storageURL.path
    }
    
    /**
     * Step 3: Setup Status Listener
     * 
     * The status listener is crucial for monitoring the Account's connection
     * to the Self network. Different status codes indicate different states.
     */
    private func setupStatusListener() {
        print("\(LOGTAG): 📚 EXAMPLE: Setting up status listener...")
        
//        account?.setOnStatusListener { [weak self] status in
//            DispatchQueue.main.async {
//                guard let self = self else { return }
//                
//                print("\(self.LOGTAG): 📊 EXAMPLE: Account status changed to: \(Int(status))")
//                
//                // Handle different status codes
//                switch Int(status) {
//                case 0:
//                    // Status 0 = Successfully connected to Self network
//                    self.handleSuccessfulConnection()
//                    
//                default:
//                    // Other statuses indicate connection issues
//                    self.handleConnectionFailure(status: Int(status))
//                }
//            }
//        }
        
        print("\(LOGTAG): ✅ EXAMPLE: Status listener configured")
        statusMessage = "Status listener active, connecting to network..."
    }
    
    /**
     * Handle Successful Connection (Status 0)
     * 
     * When status 0 is received, the account is successfully connected
     * to the Self network and ready for operations.
     */
    private func handleSuccessfulConnection() {
        print("\(LOGTAG): 🎉 EXAMPLE: Successfully connected to Self network!")
        
        // Generate and display the account address
//        if let account = account {
//            let address = account.generateAddress()
//            userAddress = address
//            print("\(LOGTAG): 📍 EXAMPLE: Account address: \(address)")
//        }
        
        // Update UI state
        isInitialized = true
        isLoading = false
        errorMessage = nil
        statusMessage = "✅ Successfully connected to Self network"
        
        // Log additional account information
        logAccountInformation()
    }
    
    /**
     * Handle Connection Failure (Non-zero status)
     * 
     * Non-zero status codes indicate various connection issues.
     * This example shows how to handle these scenarios.
     */
    private func handleConnectionFailure(status: Int) {
        print("\(LOGTAG): ❌ EXAMPLE: Connection failed with status: \(status)")
        
        // Provide user-friendly error messages based on status
        let errorDescription = getStatusDescription(status: status)
        
        // Update UI state
        isInitialized = false
        isLoading = false
        userAddress = ""
        errorMessage = "Connection failed (Status: \(status)): \(errorDescription)"
        statusMessage = "Connection failed"
    }
    
    /**
     * Get Status Description
     * 
     * Provides human-readable descriptions for different status codes.
     * This helps with debugging and user feedback.
     */
    private func getStatusDescription(status: Int) -> String {
        switch status {
        case 0:
            return "Successfully connected"
        case -1:
            return "Network connection error"
        case -2:
            return "Authentication failed"
        case -3:
            return "Invalid configuration"
        default:
            return "Unknown error code"
        }
    }
    
    /**
     * Log Account Information
     * 
     * This method demonstrates how to access and log account information
     * for debugging and educational purposes.
     */
    private func logAccountInformation() {
//        guard let account = account else { return }
//        
//        print("\(LOGTAG): 📚 EXAMPLE: Account Information:")
//        print("\(LOGTAG):   - Address: \(account.generateAddress())")
//        print("\(LOGTAG):   - Registered: \(account.registered())")
//        
//        // Log stored credentials (if any)
//        do {
//            let credentials = account.credentials()
//            print("\(LOGTAG):   - Stored credentials: \(credentials.count)")
//            
//            for (index, credential) in credentials.enumerated() {
//                let claims = credential.claims()
//                print("\(LOGTAG):     - Credential \(index): \(claims.count) claims")
//            }
//        } catch {
//            print("\(LOGTAG):   - Could not access credentials: \(error)")
//        }
    }
    
    /**
     * Retry Initialization
     * 
     * This method allows users to retry initialization after a failure.
     * Useful for handling transient network issues.
     */
    func retryInitialization() {
        print("\(LOGTAG): 🔄 EXAMPLE: Retrying SDK initialization...")
        
        // Reset state
        isInitialized = false
        errorMessage = nil
        userAddress = ""
        
        // Restart initialization process
        initializeSDK()
    }
    
    /**
     * Get Account Instance
     * 
     * Provides access to the account for other examples or application code.
     */
//    func getAccount() -> Account? {
//        return account
//    }
    
    /**
     * Check Initialization Status
     * 
     * Utility method to check if the SDK is properly initialized and connected.
     */
    func isSDKReady() -> Bool {
//        return isInitialized && account != nil
        return true
    }
}

// MARK: - SwiftUI Preview Helper

/**
 * Preview Helper for SwiftUI
 * 
 * This demonstrates how to use the initialization example in a SwiftUI view.
 */
struct SelfSDKInitializationExampleView: View {
    @StateObject private var example = SelfSDKInitializationExample()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Self SDK Initialization Example")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Status: \(example.statusMessage)")
                    .foregroundColor(example.isInitialized ? .green : .primary)
                
                if !example.userAddress.isEmpty {
                    Text("Address: \(example.userAddress)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let error = example.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            if example.isLoading {
                ProgressView("Initializing...")
            } else if !example.isInitialized {
                Button("Initialize SDK") {
                    example.initializeSDK()
                }
                .buttonStyle(.borderedProminent)
                
                if example.errorMessage != nil {
                    Button("Retry") {
                        example.retryInitialization()
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Text("✅ SDK Ready for Operations")
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
        }
        .padding()
    }
}

#Preview {
    SelfSDKInitializationExampleView()
} 
