//
//  ContentView.swift
//  Example
//
//  Created by Long Pham on 16/6/25.
//


//
//  ContentView.swift
//  ios-client
//
//  Created by Jason Reid on 06/06/2025.
//

import SwiftUI
import ui_components
import self_ios_sdk
import SelfUI

enum AppScreen: Equatable {
    case initialization
    case registrationIntro
    case applicationAddress
    case registerAccountView
    case serverConnectionSelection
    case qrCodeReader
    case serverConnection
    case serverConnectionProcessing(serverAddress: String)
    case actionSelection
    case verifyCredential
    case emailFlow
    case verifyEmailStart
    case verifyEmailResult(success: Bool)
    case verifyDocumentStart
    case verifyDocumentResult(success: Bool)
    case getCustomCredentialStart
    case getCustomCredentialResult(success: Bool)
    case shareCredential
    case shareEmailStart
    case shareEmailResult(success: Bool)
    case shareDocumentStart
    case shareDocumentResult(success: Bool)
    case shareCredentialCustomStart
    case shareCredentialCustomResult(success: Bool)
    case authStart
    case authResult(success: Bool, errorString: String?)
    case docSignStart
    case docSignResult(success: Bool)
    case backupStart
    case backupFlow
    case backupResult(success: Bool)
    case restoreStart
    case restoreFlow
    case restoreResult(success: Bool)
}

struct ContentView: View {
    private let iCloudIdentifier = "iCloud.DevApp"
    @EnvironmentObject var viewModel: MainViewModel
    
    // Track whether to show connection success toast on ActionSelectionScreen
    @State private var showConnectionSuccessToast: Bool = false
    
    // Overlay state for server requests (auth, doc signing, etc.)
    @State private var showServerRequestOverlay: Bool = false
    @State private var overlayMessage: String = ""
    @State private var serverRequestTimeoutTask: Task<Void, Never>? = nil
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    @State private var showVerifyDocument: Bool = false
    @State private var isRestoring: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.onChange(of: viewModel.appScreen) { appScreen in
                print("AppScreen: \(appScreen)")
                setCurrentAppScreen(screen: appScreen)
            }
            
            switch viewModel.appScreen {
                
            case .initialization:
                InitializeSDKScreen(isInitialized: $viewModel.isInitialized, onInitializationComplete: {
                    if let address = viewModel.getApplicationAddress() {
                        viewModel.setupAccount(withApplicationAddress: address) {
                            self.determineNextScreen()
                        }
                    } else {
                        self.setCurrentAppScreen(screen: .applicationAddress)
                    }
                })
            case .registrationIntro:
                RegistrationIntroScreen {
                    if let address = viewModel.getApplicationAddress() {
                        viewModel.setupAccount(withApplicationAddress: address) {
                            self.determineNextScreen()
                        }

                    } else {
                        self.setCurrentAppScreen(screen: .applicationAddress)
                    }
                } onRestore: {
                    self.isRestoring = true
                    self.setCurrentAppScreen(screen: .applicationAddress)
                }
                
            case .applicationAddress:
                ApplicationAddressView { address in
                    viewModel.setupAccount(withApplicationAddress: address)
                    if isRestoring {
                        self.setCurrentAppScreen(screen: .restoreStart)
                    } else {
                        self.setCurrentAppScreen(screen: .registerAccountView)
                    }
                    
                } onBack: {
                    self.setCurrentAppScreen(screen: .registrationIntro)
                }

                
            case .registerAccountView:
                RegistrationFlow(account: viewModel.getAccount()) { result in
                    switch result {
                    case .success:
                        print("Register account success.")
                        self.setCurrentAppScreen(screen: .serverConnectionSelection)
                    case .failure(let error):
                        print("Register account error: \(error)")
                    }
                }
                
            case .serverConnectionSelection:
                ServerConnectionSelectionScreen { connectionActionType in
                    if connectionActionType == .manuallyConnect {
                        self.setCurrentAppScreen(screen: .serverConnection)
                    } else if connectionActionType == .scanQrCodeConnect {
                        // MARK: QRCode Connection
                        //                        self.showQRScanner = true
                        self.setCurrentAppScreen(screen: .qrCodeReader)
                    }
                } onBack: {
                    
                }
                
            case .qrCodeReader:
                QRCodeReaderView(account: viewModel.getAccount()) { result in
                    switch result {
                    case .success(let discoveryData):
                        let serverAddress = discoveryData.address
                        let sandbox = discoveryData.sandbox
                        print("Discovery data: \(discoveryData)")
                        Task {
                            await viewModel.connectToSelfServer(discoveryData: discoveryData) { success in
                                // connection completion
                                if success {
                                    // Update server connection state and navigate to action selection
                                    viewModel.saveServerConnected(isConnected: true)
                                    viewModel.saveServerAddress(serverAddress: serverAddress.getRawValue())
                                    // Show success toast since this is first visit after connection
                                    showConnectionSuccessToast = true
                                    self.setCurrentAppScreen(screen: .actionSelection)
                                } else {
                                    print("Server connection error!")
                                }
                            }
                        }
                    case .failure(let error):
                        print("QR Code Error: \(error)")
                    }
                }
                
            case .serverConnection:
                ServerConnectionScreen(
                    onConnectToServer: { serverAddress in
                        print("Server address: \(serverAddress)")
                        self.setCurrentAppScreen(screen: .serverConnectionProcessing(serverAddress: serverAddress))
                    }) {
                        self.setCurrentAppScreen(screen: .serverConnectionSelection)
                    }
            case .serverConnectionProcessing(let serverAddress):
                ServerConnectionProcessingScreen(
                    isConnecting: $viewModel.isConnecting,
                    connectionError: $viewModel.connectionError,
                    hasTimedOut: $viewModel.hasTimedOut,
                    serverAddress: serverAddress,
                    onConnectionStart: { serverAddress in
                        print("onConnectionStart: \(serverAddress)")
                        Task {
                            await viewModel.connectToSelfServer(serverAddress: serverAddress) { success in
                                // connection completion
                                if success {
                                    // Update server connection state and navigate to action selection
                                    viewModel.saveServerConnected(isConnected: true)
                                    viewModel.saveServerAddress(serverAddress: serverAddress)
                                    // Show success toast since this is first visit after connection
                                    showConnectionSuccessToast = true
                                    self.setCurrentAppScreen(screen: .actionSelection)
                                } else {
                                    print("Server connection error!")
                                }
                            }
                        }
                        
                    },
                    onConnectionComplete: {
                        // Update server connection state and navigate to action selection
                        // Show success toast since this is first visit after connection
                        showConnectionSuccessToast = true
                        self.setCurrentAppScreen(screen: .actionSelection)
                    },
                    onGoBack: {
                        // Reset connection state and go back to server connection screen
                        self.viewModel.resetUserDefaults()
                        self.setCurrentAppScreen(screen: .serverConnectionSelection)
                    }
                )
            case .actionSelection:
                ActionSelectionScreen(
                    showConnectionSuccess: showConnectionSuccessToast,
                    onActionSelected: { actionType in
                        print("🎯 ContentView: User selected action: \(actionType)")
                        // Reset the connection success toast flag after first visit
                        showConnectionSuccessToast = false
                        handleActionSelection(actionType)
                    }, onBack: {
                        self.viewModel.resetUserDefaults()
                        self.setCurrentAppScreen(screen: .serverConnectionSelection)
                    }
                )
                
            case .authStart:
                BaseMessageView {
                    AuthStartScreen {
                        self.setCurrentAppScreen(screen: .actionSelection)
                    }
                    if let currentCredentialRequest = viewModel.currentCredentialRequest {
                        self_ios_sdk.MessageView(account: viewModel.getAccount(), message: currentCredentialRequest) { result in
                            switch result {
                            case .success (let status):
                                if status == MessageStatus.accepted.rawValue {
                                    self.setCurrentAppScreen(screen: .authResult(success: true, errorString: nil))
                                } else if status == MessageStatus.rejected.rawValue {
                                    self.setCurrentAppScreen(screen: .authResult(success: false, errorString: "User rejected the credential request."))
                                }
                            case .failure(let error):
                                print("Action failed: \(error)")
                            }
                        }
                        .padding()
                    }
                }
                
            case .authResult(let result):
                
                AuthResultScreen(success: result.success, errorString: result.errorString,
                                 onContinue: {
                    // Return to action selection (don't show connection success toast)
                    showConnectionSuccessToast = false
                    self.setCurrentAppScreen(screen: .actionSelection)
                })
                
            case .verifyCredential:
                VerifyCredentialSelectionScreen { credentialActionType in
                    if credentialActionType == .emailAddress {
                        // show verify email flow
                        self.setCurrentAppScreen(screen: .verifyEmailStart)
                    } else if credentialActionType == .identityDocument {
                        // show verify document flow
                        self.setCurrentAppScreen(screen: .verifyDocumentStart)
                    } else if credentialActionType == .customCredential {
                        self.setCurrentAppScreen(screen: .getCustomCredentialStart)
                    }
                    
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .verifyEmailStart:
                
                VerifyEmailStartScreen {
                    self.setCurrentAppScreen(screen: .emailFlow)
                    
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .emailFlow:
                self_ios_sdk.EmailFlow(account: viewModel.getAccount(), autoDismiss: true, onResult: { success in
                    print("Verify email finished = \(success)")
                    self.setCurrentAppScreen(screen: .verifyEmailResult(success: success))
                })
                
            case .verifyEmailResult (let success):
                VerifyEmailResultScreen(success: success) {
                    setCurrentAppScreen(screen: .actionSelection)
                } onBack: {
                    setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .verifyDocumentStart:
                VerifyDocumentStartScreen {
                    showVerifyDocument = true
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                .fullScreenCover(isPresented: $showVerifyDocument, onDismiss: {
                    // dismiss view
                }, content: {
                    // MARK: - Verify Documents
                    DocumentFlow(account: viewModel.getAccount(), devMode: true, autoCaptureImage: false, onResult:  { success in
                        print("Verify document finished: \(success)")
                        showVerifyDocument = false
                        setCurrentAppScreen(screen: .verifyDocumentResult(success: success))
                    })
                })
                
            case .verifyDocumentResult(let success):
                VerifyDocumentResultScreen(success: success) {
                    self.setCurrentAppScreen(screen: .actionSelection)
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .getCustomCredentialStart:
                VerifyCustomCredentialsStartScreen {
                    self.sendCustomCredentialRequest()
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .getCustomCredentialResult(let success):
                VerifyCustomCredentialsResultScreen(success: success) {
                    self.setCurrentAppScreen(screen: .actionSelection)
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .shareCredential:
                ProvideCredentialSelectionScreen { credentialActionType in
                    if credentialActionType == .emailAddress {
                        self.sendEmailCredentialRequest()
                    } else if credentialActionType == .identityDocument {
                        self.sendIDNumberCredentialRequest()
                    } else if credentialActionType == .customCredential {
                        self.requestCredentialCustomRequest()
                    }
                } onBack: {
                    viewModel.currentCredentialRequest = nil
                    viewModel.currentVerificationRequest = nil
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
            case .shareEmailStart:
                ShareEmailCredentialStartScreen {
                } onCancel: {
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                if let currentCredentialRequest = viewModel.currentCredentialRequest {
                    self_ios_sdk.MessageView(account: viewModel.getAccount(), message: currentCredentialRequest) { result in
                        switch result {
                        case .success (let status):
                            if status == MessageStatus.accepted.rawValue {
                                self.setCurrentAppScreen(screen: .shareEmailResult(success: true))
                            } else if status == MessageStatus.rejected.rawValue {
                                self.setCurrentAppScreen(screen: .actionSelection)
                                self.showToastMessage("Share email credential rejected!")
                            }
                        case .failure(let error):
                            print("Action failed: \(error)")
                        }
                    }
                    .padding()
                }
                
            case .shareEmailResult(let success):
                ShareEmailCredentialResultScreen(success: success) {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .shareDocumentStart:
                ShareDocumentCredentialStartScreen {
                    
                } onDeny: {
                    
                } onBack: {
                    setCurrentAppScreen(screen: .actionSelection)
                }
                
                if let currentCredentialRequest = viewModel.currentCredentialRequest {
                    self_ios_sdk.MessageView(account: viewModel.getAccount(), message: currentCredentialRequest) { result in
                        switch result {
                        case .success (let status):
                            if status == MessageStatus.accepted.rawValue {
                                self.setCurrentAppScreen(screen: .shareDocumentResult(success: true))
                            } else if status == MessageStatus.rejected.rawValue {
                                self.setCurrentAppScreen(screen: .actionSelection)
                                self.showToastMessage("Share document number rejected!")
                            }
                        case .failure(let error):
                            print("Action failed: \(error)")
                        }
                    }
                    .padding()
                }
                
            case .shareDocumentResult(let success):
                ShareDocumentCredentialResultScreen(success: success) {
                    setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .shareCredentialCustomStart:
                ShareCredentialStartScreen {
                } onDeny: {
                    
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                if let currentCredentialRequest = viewModel.currentCredentialRequest {
                    self_ios_sdk.MessageView(account: viewModel.getAccount(), message: currentCredentialRequest) { result in
                        switch result {
                        case .success (let status):
                            if status == MessageStatus.accepted.rawValue {
                                self.setCurrentAppScreen(screen: .shareCredentialCustomResult(success: true))
                            } else if status == MessageStatus.rejected.rawValue {
                                self.setCurrentAppScreen(screen: .actionSelection)
                                self.showToastMessage("Share custom credentials rejected!")
                            }
                        case .failure(let error):
                            print("Action failed: \(error)")
                        }
                    }
                    .padding()
                }
                
                
            case .shareCredentialCustomResult(let success):
                ShareEmailCredentialResultScreen(success: success) {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
                // MARK: DocSign
            case .docSignStart:
                BaseMessageView {
                    DocSignStartScreen {
                        self.setCurrentAppScreen(screen: .actionSelection)
                    }
                    if let currentVerificationRequest = viewModel.currentVerificationRequest {
                        self_ios_sdk.MessageView(account: viewModel.getAccount(), message: currentVerificationRequest) { result in
                            switch result {
                            case .success (let status):
                                if status == MessageStatus.accepted.rawValue {
                                    self.setCurrentAppScreen(screen: .docSignResult(success: true))
                                } else if status == MessageStatus.rejected.rawValue {
                                    self.setCurrentAppScreen(screen: .actionSelection)
                                    self.showToastMessage("Document signing rejected!")
                                }
                            case .failure(let error):
                                print("Action failed: \(error)")
                                self.setCurrentAppScreen(screen: .docSignResult(success: false))
                            }
                        }
                        .padding()
                    }
                }
                
            case .docSignResult(let success):
                DocSignResultScreen(
                    success: success,
                    onContinue: {
                        // Return to action selection (don't show connection success toast)
                        showConnectionSuccessToast = false
                        setCurrentAppScreen(screen: .actionSelection)
                    }
                )

                
            case .backupStart:
                BackupAccountStartScreen {
                    self.setCurrentAppScreen(screen: .backupFlow)
                    
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .backupFlow:
                self_ios_sdk.BackupFlow(account: viewModel.getAccount(), iCloudContainerIdentifier: iCloudIdentifier, onComplete: { result in
                    switch result {
                    case .success:
                        print("Backup completed!")
                        self.setCurrentAppScreen(screen: .backupResult(success: true))
                    case .failure(let error):
                        print("Backup failed: \(error)")
                        self.setCurrentAppScreen(screen: .backupResult(success: false))
                    }
                })
                
            case .backupResult(let success):
                BackupAccountResultScreen(success: success) {
                    // share backup file
                    self.setCurrentAppScreen(screen: .actionSelection)
                } onBack: {
                    self.setCurrentAppScreen(screen: .actionSelection)
                }
                
            case .restoreStart:
                RestoreAccountStartScreen {
                    self.setCurrentAppScreen(screen: .restoreFlow)
                } onBack: {
                    self.setCurrentAppScreen(screen: .registrationIntro)
                }
            case .restoreFlow:
                self_ios_sdk.RestoreFlow(account: viewModel.getAccount(), iCloudContainerIdentifier: iCloudIdentifier, onComplete: { result in
                    print("RestoreFlow complete: \(result)")
                    switch result {
                    case .success:
                        self.setCurrentAppScreen(screen: .serverConnectionSelection)
                    case .failure( let error):
                        // show restore error
                        print("TODO: display toast message for restore error: \(error)")
                    }
                })
                
                
            case .restoreResult(let success):
                RestoreAccountResultScreen(success: success) {
                    self.setCurrentAppScreen(screen: .actionSelection)
                } onBack: {
                    
                }
            }
            
            // Server request overlay (blocks interaction while waiting for server response)
            if showServerRequestOverlay {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Block all interactions
                    }
                
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text(overlayMessage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            
            // Toast notification
            if showToast {
                ToastMessageView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    private func setCurrentAppScreen(screen: AppScreen) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.viewModel.appScreen = screen
            }
        }
    }
    
    private func determineNextScreen() {
        print("🎯 ContentView: Determining next screen based on account status...")
        
        // Check if account is registered
        let isRegistered = viewModel.accountIsRegistered()//account.registered()
        print("🎯 ContentView: Account registered: \(isRegistered)")
        
        // Check stored connection state and validate it
        let storedConnectionState = viewModel.getServerConnected()
        let storedServerAddress =  viewModel.getServerAddress()
        print("🎯 ContentView: Stored server connection state: \(storedConnectionState)")
        print("🎯 ContentView: Stored server address: \(storedServerAddress ?? "nil")")
        
        // Validate connection state - both must be present for a valid connection
        let hasValidConnection = storedConnectionState && storedServerAddress != nil
        if storedConnectionState && storedServerAddress == nil {
            print("🎯 ContentView: ⚠️ Inconsistent state: connection marked as true but no server address. Resetting connection state.")
            // Reset inconsistent state
            viewModel.resetUserDefaults()
        }
        
        let isServerConnected = hasValidConnection
        let connectedServerAddress = storedServerAddress
        print("🎯 ContentView: Final server connected state: \(isServerConnected)")
        print("🎯 ContentView: Final server address: \(connectedServerAddress ?? "nil")")
        
        withAnimation(.easeInOut(duration: 0.5)) {
            if isRegistered && isServerConnected {
                print("🎯 ContentView: Account registered AND server connected, navigating to ACTION_SELECTION")
                // Set up message listener if we have a stored server connection
                //viewModel.setupMessageListener()
                // Don't show connection success toast since user is already connected
                showConnectionSuccessToast = false
                self.setCurrentAppScreen(screen: .actionSelection)
            } else if isRegistered {
                print("🎯 ContentView: Account registered but not connected to server, navigating to SERVER_CONNECTION")
                self.setCurrentAppScreen(screen: .serverConnectionSelection)
            } else {
                print("🎯 ContentView: Account not registered, navigating to REGISTRATION_INTRO")
                self.setCurrentAppScreen(screen: .registrationIntro)
            }
        }
    }
    
    // MARK: - Action Handling
    
    private func handleActionSelection(_ actionType: ActionType) {
        switch actionType {
        case .authenticate:
            self.notifyServerForRequest(requestMessage: SERVER_REQUESTS.REQUEST_CREDENTIAL_AUTH) { messageId, error in
                if error == nil {
                    print("Notify server for AUTH success with messageId: \(messageId)")
                } else {
                    print("Notify server for AUTH error: \(error)")
                }
            }
        case .verifyCredentials:
            handleVerifyCredentials()
        case .provideCredentials:
            self.setCurrentAppScreen(screen: .shareCredential)
        case .signDocuments:
            self.setCurrentAppScreen(screen: .docSignStart)
            self.notifyServerForRequest(requestMessage: SERVER_REQUESTS.REQUEST_DOCUMENT_SIGNING) { messageId, error in
                if error == nil {
                    print("Notify server for REQUEST_DOCUMENT_SIGNING success with messageId: \(messageId)")
                } else {
                    print("Notify server for REQUEST_DOCUMENT_SIGNING error: \(String(describing: error))")
                }
            }
            
        case .backup:
            self.setCurrentAppScreen(screen: .backupStart)
        @unknown default:
            fatalError()
        }
    }
    
    private func notifyServerForRequest(requestMessage: String, completion: @escaping ((String, Error?) -> Void)) {
        showServerRequestOverlay = true
        viewModel.notifyServerForRequest(message: requestMessage) { messageId, error in
            Task { @MainActor in
                completion(messageId, error)
                self.showServerRequestOverlay = false
                if let error = error {
                    print("🔐 ContentView: ❌ Authentication request send failed: \(error)")
                    showServerRequestOverlay = false
                    showToastMessage("Failed to send authentication request: \(error.localizedDescription)")
                } else {
                    print("🔐 ContentView: ✅ Authentication request sent successfully with ID: \(messageId)")
                    // Message sent successfully, now waiting for server response via message listener
                }
            }
        }
    }
    
    private func sendAuthenticationRequest() {
        print("🔐 ContentView: Sending authentication request message to server...")
        viewModel.notifyServerForRequest(message: SERVER_REQUESTS.REQUEST_CREDENTIAL_AUTH) { messageId, error in
            Task { @MainActor in
                if let error = error {
                    print("🔐 ContentView: ❌ Authentication request send failed: \(error)")
                    showServerRequestOverlay = false
                    showToastMessage("Failed to send authentication request: \(error.localizedDescription)")
                } else {
                    print("🔐 ContentView: ✅ Authentication request sent successfully with ID: \(messageId)")
                    // Message sent successfully, now waiting for server response via message listener
                }
            }
        }
    }
    
    private func sendEmailCredentialRequest(completion: ((Bool) -> Void)? = nil) {
        print("🔐 ContentView: Sending email request message to server...")
        viewModel.notifyServerForRequest(message: SERVER_REQUESTS.REQUEST_CREDENTIAL_EMAIL) { messageId, error in
            Task { @MainActor in
                if let error = error {
                    print("🔐 ContentView: ❌ Email credential request send failed: \(error)")
                    showServerRequestOverlay = false
                    showToastMessage("Failed to send email credential request: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    print("🔐 ContentView: ✅ Email credential request sent successfully with ID: \(messageId)")
                    // Message sent successfully, now waiting for server response via message listener
                    completion?(true)
                }
            }
        }
    }
    
    private func requestCredentialCustomRequest() {
        print("🔐 ContentView: Sending custom credential request message to server...")
        viewModel.notifyServerForRequest(message: SERVER_REQUESTS.REQUEST_CREDENTIAL_CUSTOM) { messageId, error in
            Task { @MainActor in
                if let error = error {
                    print("🔐 ContentView: ❌ Get custom credentials request send failed: \(error)")
                    showServerRequestOverlay = false
                    showToastMessage("Failed to send custom credentials request: \(error.localizedDescription)")
                } else {
                    print("🔐 ContentView: ✅ custom credentials request sent successfully with ID: \(messageId)")
                    // Message sent successfully, now waiting for server response via message listener
                }
            }
        }
    }
    
    private func sendCustomCredentialRequest() {
        print("🔐 ContentView: Sending custom credential request message to server...")
        viewModel.notifyServerForRequest(message: SERVER_REQUESTS.REQUEST_GET_CUSTOM_CREDENTIAL) { messageId, error in
            Task { @MainActor in
                if let error = error {
                    print("🔐 ContentView: ❌ Get custom credentials request send failed: \(error)")
                    showServerRequestOverlay = false
                    showToastMessage("Failed to send custom credentials request: \(error.localizedDescription)")
                } else {
                    print("🔐 ContentView: ✅ custom credentials request sent successfully with ID: \(messageId)")
                    // Message sent successfully, now waiting for server response via message listener
                }
            }
        }
    }
    
    private func sendIDNumberCredentialRequest() {
        print("🔐 ContentView: Sending ID Number credential request message to server...")
        viewModel.notifyServerForRequest(message: SERVER_REQUESTS.REQUEST_CREDENTIAL_DOCUMENT) { messageId, error in
            Task { @MainActor in
                if let error = error {
                    print("🔐 ContentView: ❌ Authentication request send failed: \(error)")
                    showServerRequestOverlay = false
                    showToastMessage("Failed to send document credential request: \(error.localizedDescription)")
                } else {
                    print("🔐 ContentView: ✅ Document credential request sent successfully with ID: \(messageId)")
                    // Message sent successfully, now waiting for server response via message listener
                }
            }
        }
    }
    
    // MARK: - Verify Credentials
    
    private func handleVerifyCredentials() {
        self.setCurrentAppScreen(screen: .verifyCredential)
    }
    
    private func sendVerificationResponse(account: Account, accepted: Bool) {
        print("📄 ContentView: Sending verification response back to server...")
        
        guard let verificationRequest = viewModel.currentVerificationRequest else {
            print("📄 ContentView: ❌ Cannot send verification response - no stored verification request")
            return
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        
        // Auto-hide toast after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                showToast = false
            }
        }
    }
    
    // MARK: - State Management & Data Persistence
    
    /// Clears all app-specific state.
    ///
    /// **Data Persistence & App Uninstall Behavior:**
    /// - UserDefaults: Automatically cleared on app uninstall (iOS sandbox behavior)
    /// - Self SDK storage: Uses app Documents directory, automatically cleared on uninstall
    /// - Self SDK Keychain items: Managed by Self SDK with appropriate accessibility settings
    ///   (typically cleared on uninstall, but may depend on SDK configuration)
    ///
    /// This method can be used for development/testing or explicit reset functionality.
    /// It only clears app-level state, not Self SDK internal state (keys, credentials).
    private func clearAllAppState() {
        print("🧹 ContentView: Clearing all app-specific persistent state")
        // Reset to initial screen
        viewModel.appScreen = .initialization
    }
}

//#Preview {
//    ContentView()
//}

