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
    case serverConnectionSelection
    case serverConnection
    case serverConnectionProcessing(serverAddress: String)
    case actionSelection
    case verifyCredential
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
    case authResult(success: Bool)
    case docSignStart
    case docSignResult(success: Bool)
    case backupStart
    case backupResult(success: Bool)
    case restoreStart
    case restoreResult(success: Bool)
}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var currentScreen: AppScreen = .initialization
    
    // Track whether to show connection success toast on ActionSelectionScreen
    @State private var showConnectionSuccessToast: Bool = false
    
    // Overlay state for server requests (auth, doc signing, etc.)
    @State private var showServerRequestOverlay: Bool = false
    @State private var overlayMessage: String = ""
    @State private var serverRequestTimeoutTask: Task<Void, Never>? = nil
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    // Current credential request (needed to send response back)
    @State private var currentCredentialRequest: CredentialRequest? = nil
    
    // Current verification request (needed to send response back)
    @State private var currentVerificationRequest: VerificationRequest? = nil
    
    @State private var showVerifyEmail: Bool = false
    @State private var showVerifyDocument: Bool = false
    
    // backup & restore
    @State private var isBackingUp = false
    @State private var showDocumentPicker = false
    @State private var selectedFileName: String?
    @State private var selectedFileURLs: [URL] = []
    @State private var fileToShareURLs: [URL] = []
    @State private var showShareSheet = false
    
    @State private var showQRScanner = false
    @State private var isCodeValid = false
    
    @State private var isRestoring = false
    @State private var isRegistering = false
    
    var body: some View {
        ZStack {
            Color.white.onChange(of: viewModel.appScreen) { appScreen in
                print("AppScreen: \(appScreen)")
                setCurrentAppScreen(screen: appScreen)
            }
            
            Group {
//                switch currentScreen {
//                case .initialization:
//                    InitializeSDKScreen(isInitialized: $viewModel.isInitialized, onInitializationComplete: {
//                        determineNextScreen()
//                    })
//                case .registrationIntro:
//                    RegistrationIntroScreen(isProcessing: $isRegistering) {
//                        // start registration
//                        self.isRegistering = true
//                        viewModel.registerAccount { success in
//                            viewModel.accountRegistered = success
//                            self.isRegistering = success
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .serverConnectionSelection
//                            }
//                        }
//                    } onRestore: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .restoreStart
//                        }
//                    }
//                    
//                case .serverConnectionSelection:
//                    ServerConnectionSelectionScreen { connectionActionType in
//                        if connectionActionType == .manuallyConnect {
//                            self.setCurrentAppScreen(screen: .serverConnection)
//                        } else if connectionActionType == .scanQrCodeConnect {
//                            // MARK: QRCode Connection
//                            self.showQRScanner = true
//                        }
//                    } onBack: {
//                        
//                    }
//                    .fullScreenCover(isPresented: $showQRScanner, onDismiss: {
//                        
//                    }, content: {
//                        QRReaderView(isCodeValid: $isCodeValid, onCode: { code in
//                            print("QRCode: \(code)")
//                        }) { codeData in
//                            print("QRCode: \(codeData)")
//                            viewModel.handleAuthData(data: codeData) { error in
//                                if error == nil {
//                                    showQRScanner = false
//                                    self.setCurrentAppScreen(screen: .actionSelection)
//                                }
//                            }
//                        }
//                    })
//
//                    
//                case .serverConnection:
//                    ServerConnectionScreen(
//                        onConnectToServer: { serverAddress in
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .serverConnectionProcessing(serverAddress: serverAddress)
//                            }
//                        }
//                    )
//                case .serverConnectionProcessing(let serverAddress):
//                    ServerConnectionProcessingScreen(
//                        isConnecting: $viewModel.isConnecting,
//                        connectionError: $viewModel.connectionError,
//                        hasTimedOut: $viewModel.hasTimedOut,
//                        serverAddress: serverAddress,
//                        onConnectionStart: { serverAddress in
//                            print("onConnectionStart: \(serverAddress)")
//                            Task {
//                                await viewModel.connectToSelfServer(serverAddress: serverAddress) { success in
//                                    // connection completion
//                                    if success {
//                                        // Update server connection state and navigate to action selection
//                                        viewModel.saveServerConnected(isConnected: true)
//                                        viewModel.saveServerAddress(serverAddress: serverAddress)
//                                        // Show success toast since this is first visit after connection
//                                        showConnectionSuccessToast = true
//                                        self.setCurrentAppScreen(screen: .actionSelection)
//                                    } else {
//                                        print("Server connection error!")
//                                    }
//                                }
//                            }
//                            
//                        },
//                        onConnectionComplete: {
//                            // Update server connection state and navigate to action selection
//                            // Show success toast since this is first visit after connection
//                            showConnectionSuccessToast = true
//                            self.setCurrentAppScreen(screen: .actionSelection)
//                        },
//                        onGoBack: {
//                            // Reset connection state and go back to server connection screen
//                            self.viewModel.resetUserDefaults()
//                            self.setCurrentAppScreen(screen: .serverConnectionSelection)
//                        }
//                    )
//                case .actionSelection:
//                    ActionSelectionScreen(
//                        showConnectionSuccess: showConnectionSuccessToast,
//                        onActionSelected: { actionType in
//                            print("🎯 ContentView: User selected action: \(actionType)")
//                            // Reset the connection success toast flag after first visit
//                            showConnectionSuccessToast = false
//                            handleActionSelection(actionType)
//                        }, onBack: {
//                            self.viewModel.resetUserDefaults()
//                            self.setCurrentAppScreen(screen: .serverConnectionSelection)
//                        }
//                    )
//                    
//                case .verifyCredential:
//                    VerifyCredentialSelectionScreen { credentialActionType in
//                        if credentialActionType == .emailAddress {
//                            // show verify email flow
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .verifyEmailStart
//                            }
//                        } else if credentialActionType == .identityDocument {
//                            // show verify document flow
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .verifyDocumentStart
//                            }
//                        } else if credentialActionType == .customCredential {
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .getCustomCredentialStart
//                            }
//                        }
//                        
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                    
//                case .verifyEmailStart:
//                    VerifyEmailStartScreen {
//                        showVerifyEmail = true
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                    .fullScreenCover(isPresented: $showVerifyEmail, onDismiss: {
//                        
//                    }, content: {
//                        EmailFlow(account: viewModel.account, autoDismiss: false, onResult: { success in
//                            print("Verify email finished = \(success)")
//                            self.showVerifyEmail = false
//                            self.setCurrentAppScreen(screen: .verifyEmailResult(success: success))
//                        })
//                    })
//                    
//                case .verifyEmailResult (let success):
//                    VerifyEmailResultScreen(success: success) {
//                        setCurrentAppScreen(screen: .actionSelection)
//                    } onBack: {
//                        setCurrentAppScreen(screen: .actionSelection)
//                    }
//
//                case .verifyDocumentStart:
//                    VerifyDocumentStartScreen {
//                        showVerifyDocument = true
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                    .fullScreenCover(isPresented: $showVerifyDocument, onDismiss: {
//                        // dismiss view
//                    }, content: {
//                        // MARK: - Verify Documents
//                        DocumentFlow(account: viewModel.account, devMode: true, autoCaptureImage: false, onResult:  { success in
//                            print("Verify document finished: \(success)")
//                            showVerifyDocument = false
//                            setCurrentAppScreen(screen: .verifyDocumentResult(success: success))
//                        })
//                    })
//                    
//                case .verifyDocumentResult(let success):
//                    VerifyDocumentResultScreen(success: success) {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//
//                case .getCustomCredentialStart:
//                    VerifyCustomCredentialsStartScreen {
//                        self.sendCustomCredentialRequest()
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//
//                case .getCustomCredentialResult(let success):
//                    VerifyCustomCredentialsResultScreen(success: success) {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//
//                    
//                case .shareCredential:
//                    ProvideCredentialSelectionScreen { credentialActionType in
//                        if credentialActionType == .emailAddress {
//                            self.sendEmailCredentialRequest { success in
//                                if success {
//                                    self.setCurrentAppScreen(screen: .shareEmailStart)
//                                }
//                            }
//                        } else if credentialActionType == .identityDocument {
//                            self.sendIDNumberCredentialRequest()
//                        } else if credentialActionType == .customCredential {
//                            self.requestCredentialCustomRequest()
//                        }
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                case .shareEmailStart:
//                    ShareEmailCredentialStartScreen {
//                        viewModel.responseToCredentialRequest(credentialRequest: nil, responseStatus: .accepted) { messageId, error in
//                            let success = error == nil
//                            self.setCurrentAppScreen(screen: .shareEmailResult(success: success))
//                        }
//                    } onCancel: {
//                        viewModel.responseToCredentialRequest(credentialRequest: nil, responseStatus: .rejected) { messageId, error in
//                            let success = error == nil
//                            self.setCurrentAppScreen(screen: .actionSelection)
//                            self.showToastMessage("Share credential rejected!")
//                        }
//                    } onBack: {
//                        self.setCurrentAppScreen(screen: .actionSelection)
//                    }
//
//                case .shareEmailResult(let success):
//                    ShareEmailCredentialResultScreen(success: success) {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                
//                case .shareDocumentStart:
//                    ShareDocumentCredentialStartScreen {
//                        viewModel.responseToCredentialRequest(credentialRequest: currentCredentialRequest, responseStatus: .accepted) { messageId, error in
//
//                            let success = error == nil
//                            setCurrentAppScreen(screen: .shareDocumentResult(success: success))
//                        }
//                    } onDeny: {
//                        viewModel.responseToCredentialRequest(credentialRequest: currentCredentialRequest, responseStatus: .rejected) { messageId, error in
//                            self.setCurrentAppScreen(screen: .actionSelection)
//                            self.showToastMessage("Share document rejected!")
//                        }
//                    } onBack: {
//                        setCurrentAppScreen(screen: .actionSelection)
//                    }
//
//                    
//                case .shareDocumentResult(let success):
//                    ShareDocumentCredentialResultScreen(success: success) {
//                        setCurrentAppScreen(screen: .actionSelection)
//                    }
//                    
//                case .shareCredentialCustomStart:
//                    ShareCredentialStartScreen {
//                        viewModel.responseToCredentialRequest(credentialRequest: currentCredentialRequest, responseStatus: .accepted) { messageId, error in
//                            if error == nil {
//                                withAnimation(.easeInOut(duration: 0.5)) {
//                                    currentScreen = .shareCredentialCustomResult(success: true)
//                                }
//                            } else {
//                                withAnimation(.easeInOut(duration: 0.5)) {
//                                    currentScreen = .shareCredentialCustomResult(success: false)
//                                }
//                            }
//                        }
//                    } onDeny: {
//                        viewModel.responseToCredentialRequest(credentialRequest: currentCredentialRequest, responseStatus: .rejected)
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//
//                    
//                case .shareCredentialCustomResult(let success):
//                    ShareEmailCredentialResultScreen(success: success) {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                    
//                case .authStart:
//                    AuthStartScreen(
//                        onStartAuthentication: {
//                            startAuthenticationLivenessCheck()
//                        }, onRejectAuthentication: {
//                            // reject authentication
//                            viewModel.responseToCredentialRequest(credentialRequest: nil, responseStatus: .rejected) { messageId, error in
//                                if error == nil {
//                                    self.setCurrentAppScreen(screen: .actionSelection)
//                                    showToastMessage("Authentication rejected!")
//                                }
//                            }
//                        }
//                    )
//                case .authResult(let success):
//                    AuthResultScreen(success: success,
//                        onContinue: {
//                            // Return to action selection (don't show connection success toast)
//                            showConnectionSuccessToast = false
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .actionSelection
//                            }
//                        }
//                    )
//                case .docSignStart:
//                    DocSignStartScreen(
//                        onSignDocument: {
//                            viewModel.respondToVerificationRequest(verificationRequest: nil, status: .accepted, completion: { messageId, error in
//                                if error == nil {
//                                    self.setCurrentAppScreen(screen: .docSignResult(success: true))
//                                } else {
//                                    self.setCurrentAppScreen(screen: .docSignResult(success: false))
//                                }
//                            })
//                        },
//                        onRejectDocument: {
//                            viewModel.respondToVerificationRequest(verificationRequest: nil, status: .rejected, completion: { messageId, error in
//                                self.setCurrentAppScreen(screen: .actionSelection)
//                                self.showToastMessage("Document signing rejected!")
//                            })
//                        }
//                    )
//                case .docSignResult(let success):
//                    DocSignResultScreen(
//                        success: success,
//                        onContinue: {
//                            // Return to action selection (don't show connection success toast)
//                            showConnectionSuccessToast = false
//                            setCurrentAppScreen(screen: .actionSelection)
//                        }
//                    )
//                    
//                    // MARK: Backup & Restore
//                case .backupStart:
//                    BackupAccountStartScreen(isProcessing: $isBackingUp) {
//                        self.isBackingUp = true
//                        viewModel.backup { backupFile in
//                            // open share extension to save file
//                            if let url = backupFile {
//                                fileToShareURLs = [url]
//                            }
//                            self.isBackingUp = false
//                            
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .backupResult(success: backupFile != nil)
//                            }
//                        }
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                
//                case .backupResult(let success):
//                    BackupAccountResultScreen(success: success) {
//                        // share backup file
//                        showShareSheet = true
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .actionSelection
//                        }
//                    }
//                    .sheet(isPresented: $showShareSheet) {
//                        ShareSheet(items: fileToShareURLs) {
//                            self.showShareSheet = false
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                currentScreen = .actionSelection
//                            }
//                        }
//                    }
//                    
//                case .restoreStart:
//                    RestoreAccountStartScreen(isProcessing: $isRestoring) {
//                        showDocumentPicker = true
//                    } onBack: {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .registrationIntro
//                        }
//                    }
//                    .onChange(of: self.selectedFileURLs, perform: { newValue in
//                        print("Files change: \(newValue)")
//                        if let url = newValue.first, url.pathExtension == "self_backup" {
//                            // handle restore account
//                            if url.startAccessingSecurityScopedResource() {
//                                print("startAccessingSecurityScopedResource")
//                            }
//                            
//                            // 1. Do liveness to get liveness's selfie image
//                            SelfSDK.showLiveness(account: viewModel.account, showIntroduction: true, autoDismiss: true, isVerificationRequired: false, onResult: { selfieImageData, credentials, error in
//                                print("showLivenessCheck credentials: \(credentials)")
//                                self.isRestoring = true
//                                viewModel.restore(selfieData: selfieImageData, backupFile: url) { success in
//                                    print("Restore account finished: \(success)")
//                                    self.isRestoring = false
//                                    withAnimation(.easeInOut(duration: 0.5)) {
//                                        currentScreen = .restoreResult(success: success)
//                                    }
//                                }
//                            })
//                        }
//                    })
//                    .sheet(isPresented: $showDocumentPicker) {
//                        DocumentPicker(selectedFileName: $selectedFileName, selectedFileURLs: $selectedFileURLs)
//                    }
//
//                
//                case .restoreResult(let success):
//                    RestoreAccountResultScreen(success: success) {
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            currentScreen = .serverConnectionSelection
//                        }
//                    } onBack: {
//                        
//                    }
//
//
//                }
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
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = screen
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
                currentScreen = .actionSelection
            } else if isRegistered {
                print("🎯 ContentView: Account registered but not connected to server, navigating to SERVER_CONNECTION")
                currentScreen = .serverConnectionSelection
            } else {
                print("🎯 ContentView: Account not registered, navigating to REGISTRATION_INTRO")
                currentScreen = .registrationIntro
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
//            print("🎯 ContentView: Provide Credentials selected (not implemented yet)")
//            showToastMessage("Provide Credentials feature coming soon!")
            withAnimation(.easeInOut(duration: 0.5)) {
                currentScreen = .shareCredential
            }
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
            withAnimation(.easeInOut(duration: 0.5)) {
                currentScreen = .backupStart
            }
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
    
    private func startAuthenticationLivenessCheck() {
        print("🔐 ContentView: Starting authentication liveness check with SelfUI")
        
        // Use SelfUI to perform liveness check
//        SelfSDK.showLiveness(account: viewModel.account) { data, credentials, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("🔐 ContentView: ❌ Authentication liveness check failed: \(error)")
//                    showToastMessage("Authentication failed. Please try again.")
//                    // Stay on current screen to allow retry
//                } else {
//                    print("🔐 ContentView: ✅ Authentication liveness check successful")
//                    print("🔐 ContentView: Received \(credentials.count) credentials")
//                    
//                    // Send credential response back to server
////                    sendCredentialResponse(account: account, credentials: credentials)
//                    viewModel.responseToCredentialRequest(credentialRequest: nil, responseStatus: .accepted) { messsageId, error in
//                        let success = error == nil
//                        // Navigate to result screen
//                        self.setCurrentAppScreen(screen: .authResult(success: success))
//                    }
//                }
//            }
//        }
    }
    
    // MARK: - Verify Credentials
    
    private func handleVerifyCredentials() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .verifyCredential
        }
    }
    
//    private func sendCredentialResponse(account: Account, credentials: [Credential]) {
//        print("🔐 ContentView: Sending credential response back to server...")
//        
//        guard let credentialRequest = currentCredentialRequest else {
//            print("🔐 ContentView: ❌ Cannot send credential response - no stored credential request")
//            return
//        }
//        
//        Task {
//            do {
//                let credentialResponse = CredentialResponse.Builder()
//                    .withRequestId(credentialRequest.id())
//                    .withTypes(credentialRequest.types())
//                    .toIdentifier(credentialRequest.toIdentifier())
//                    .withStatus(ResponseStatus.accepted)
//                    .withCredentials(credentials)
//                    .build()
//                
//                try await account.send(message: credentialResponse, onAcknowledgement: { messageId, error in
//                    Task { @MainActor in
//                        if let error = error {
//                            print("🔐 ContentView: ❌ Credential response send failed: \(error)")
//                            showToastMessage("Failed to send authentication response: \(error.localizedDescription)")
//                        } else {
//                            print("🔐 ContentView: ✅ Credential response sent successfully with ID: \(messageId)")
//                            // Clear the stored request since we've responded to it
//                            currentCredentialRequest = nil
//                        }
//                    }
//                })
//            } catch {
//                print("🔐 ContentView: ❌ Failed to build credential response: \(error)")
//                showToastMessage("Failed to build authentication response: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func sendVerificationResponse(account: Account, accepted: Bool) {
        print("📄 ContentView: Sending verification response back to server...")
        
        guard let verificationRequest = currentVerificationRequest else {
            print("📄 ContentView: ❌ Cannot send verification response - no stored verification request")
            return
        }
        
//        Task {
//            do {
//                let status = accepted ? ResponseStatus.accepted : ResponseStatus.rejected
//                let verificationResponse = VerificationResponse.Builder()
//                    .withRequestId(verificationRequest.id())
//                    .withTypes(verificationRequest.types())
//                    .toIdentifier(verificationRequest.toIdentifier())
//                    .fromIdentifier(verificationRequest.fromIdentifier())
//                    .withStatus(status)
//                    .build()
//                
//                try await account.send(message: verificationResponse, onAcknowledgement: { messageId, error in
//                    Task { @MainActor in
//                        if let error = error {
//                            print("📄 ContentView: ❌ Verification response send failed: \(error)")
//                            showToastMessage("Failed to send document signing response: \(error.localizedDescription)")
//                        } else {
//                            print("📄 ContentView: ✅ Verification response sent successfully with ID: \(messageId)")
//                            // Clear the stored request since we've responded to it
//                            currentVerificationRequest = nil
//                        }
//                    }
//                })
//            } catch {
//                print("📄 ContentView: ❌ Failed to build verification response: \(error)")
//                showToastMessage("Failed to build document signing response: \(error.localizedDescription)")
//            }
//        }
    }
    
    private func handleIncomingRequest(_ request: Any) {
        print("🎯 ContentView: 📥 Received incoming request of type: \(type(of: request))")
        
        if let credentialRequest = request as? CredentialRequest {
            handleIncomingCredentialRequest(credentialRequest)
        } else if let verificationRequest = request as? VerificationRequest {
            handleIncomingVerificationRequest(verificationRequest)
        } else {
            print("🎯 ContentView: ❓ Unknown request type: \(type(of: request))")
        }
    }
    
    private func handleIncomingMessage(_ message: Any) {
        print("🎯 ContentView: 📥 Received incoming message of type: \(type(of: message))")
        
        if let chatMessage = message as? ChatMessage {
            handleIncomingChatMessage(chatMessage)
        } else if let credentialMessage = message as? CredentialMessage {
            self.handleIncomingCredentialMessage(credentialMessage)
            
        } else {
            print("🎯 ContentView: ❓ Unknown message type: \(type(of: message))")
        }
    }
    
    private func handleIncomingCredentialRequest(_ credentialRequest: CredentialRequest) {
//        let fromAddress = credentialRequest.fromIdentifier()
//        print("🎯 ContentView: 🎫 Credential request from \(fromAddress)")
//        
//        // Store the credential request so we can respond to it later
//        currentCredentialRequest = credentialRequest
//        
//        // check credential request type
//        
//        // Cancel timeout if waiting for auth request
//        serverRequestTimeoutTask?.cancel()
//        
//        // Hide overlay and navigate to AUTH_START
//        showServerRequestOverlay = false
//        let emailCredential = credentialRequest.details().first?.types().contains(CredentialType.Email) ?? false
//        let documentCredential = credentialRequest.details().first?.types().contains(CredentialType.Passport) ?? false
//        let customCredential = credentialRequest.details().first?.types().contains("CustomerCredential") ?? false
//        
//        if emailCredential {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                currentScreen = .shareEmailStart
//            }
//        } else if documentCredential {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                currentScreen = .shareDocumentStart
//            }
//        } else if customCredential {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                currentScreen = .shareCredentialCustomStart
//            }
//        }else {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                currentScreen = .authStart
//            }
//        }
    }
    
    
    
    private func handleIncomingVerificationRequest(_ verificationRequest: VerificationRequest) {
//        let fromAddress = verificationRequest.fromIdentifier()
//        print("🎯 ContentView: 📝 Verification request from \(fromAddress)")
//        
//        // Store the verification request so we can respond to it later
//        currentVerificationRequest = verificationRequest
//        
//        // Cancel timeout if waiting for doc signing request
//        serverRequestTimeoutTask?.cancel()
//        
//        // Hide overlay and navigate to DOC_SIGN_START
//        showServerRequestOverlay = false
//        withAnimation(.easeInOut(duration: 0.5)) {
//            currentScreen = .docSignStart
//        }
    }
    
    private func handleIncomingChatMessage(_ chatMessage: ChatMessage) {
//        let messageContent = chatMessage.message()
//        let fromAddress = chatMessage.fromIdentifier()
//        print("🎯 ContentView: 💬 Chat message from \(fromAddress): '\(messageContent)'")
        // Chat messages are informational, no specific action needed
    }
    
    private func handleIncomingCredentialMessage(_ credentialMessage: CredentialMessage) {
//        let messageContent = credentialMessage.credentials()
//        let fromAddress = credentialMessage.fromIdentifier()
//        
//        print("🎯 ContentView: 💬 Credential message from \(fromAddress): '\(messageContent)'")
//        // Chat messages are informational, no specific action needed
//        withAnimation(.easeInOut(duration: 0.5)) {
//            currentScreen = .getCustomCredentialResult(success: true)
//        }
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
        currentScreen = .initialization
    }
}

//#Preview {
//    ContentView()
//}
