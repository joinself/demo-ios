//
//  MainViewModel.swift
//  Example
//
//  Created by Long Pham on 8/5/25.
//

import Foundation
import Combine
import self_ios_sdk

struct CredentialItem: Identifiable {
    var id: String = UUID().uuidString
    var claims: [String]
}

struct SERVER_REQUESTS {
    static let REQUEST_CREDENTIAL_AUTH: String = "REQUEST_CREDENTIAL_AUTH"
    static let REQUEST_CREDENTIAL_EMAIL: String = "PROVIDE_CREDENTIAL_EMAIL"
    static let REQUEST_CREDENTIAL_DOCUMENT: String = "PROVIDE_CREDENTIAL_DOCUMENT"
    static let REQUEST_CREDENTIAL_CUSTOM: String = "PROVIDE_CREDENTIAL_CUSTOM"
    static let REQUEST_DOCUMENT_SIGNING: String = "REQUEST_DOCUMENT_SIGNING"
    static let REQUEST_GET_CUSTOM_CREDENTIAL: String = "REQUEST_GET_CUSTOM_CREDENTIAL"
}

struct UserDefaultKeys {
    static let isServerConnected = "isServerConnected"
    static let connectedServerAddress = "connectedServerAddress"
}

final class MainViewModel: ObservableObject {
    @Published var isOnboardingCompleted: Bool = false
    
    let account: Account
    @Published var accountRegistered: Bool = false
    @Published var isInitialized: Bool = false
    
    @Published var isConnecting = true
    @Published var connectionError: String? = nil
    @Published var hasTimedOut = false
    
    private var serverAddress:String?
    @Published var appScreen: AppScreen = .initialization
    private var isServerConnected: Bool = false
    private var connectedServerAddress: String?
    
    private var currentCredentialRequest: CredentialRequest? = nil
    private var currentVerificationRequest: VerificationRequest? = nil
    
    init() {
        // Initialize SDK
        SelfSDK.initialize()
        
        account = Account.Builder()
            .withEnvironment(Environment.production)
            .withSandbox(true) // if true -> production
            .withGroupId("") // ex: com.example.app.your_app_group
            .withStoragePath(FileManager.storagePath)
            .build()
        
        isServerConnected = self.getServerConnected()
        connectedServerAddress = self.getServerAddress()
        serverAddress = connectedServerAddress
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isInitialized = true
        }
        
        // add listener
//        setupMessageListener()
    }
    
    // MARK: - Message Handling
    
    /*
    func setupMessageListener() {
        account.setOnInfoRequest { (key: String) in
            print("setOnInfoRequest: \(key)")
        }

        account.setOnInfoResponse { (address: String, data: [String: Any]) in
            print("setOnInfoResponse: \(address)/\(data)")
        }

        account.setOnStatusListener { status in
            print("init account status:\(status)")
            // reload credentials view
            Task { @MainActor in
                self.accountRegistered = self.account.registered()
            }
            self.reloadCredentialItems()
        }

        account.setOnRelayConnectListener {
            print("onRelayConnect connected.")
        }

        account.setOnMessageListener { message in
            print("Message received: \(message.id())")
            switch message {
            case is ChatMessage:
                let chatMessage = message as! ChatMessage
                //self.handleIncomingChatMessage(chatMessage)

            case is CredentialMessage:
                let credentialMessage = message as! CredentialMessage
                self.handleIncomingCredentialMessage(credentialMessage)
            case is Receipt:
                let receipt = message as! Receipt

            default:
                print("🎯 ContentView: ❓ Unknown message type: \(type(of: message))")
                break
            }
        }

        account.setOnRequestListener { message in
            print("setOnRequestListener: \(message)")
            switch message {
            case is CredentialRequest:
                let credentialRequest = message as! CredentialRequest
                self.handleCredentialRequest(credentialRequest: credentialRequest)

            case is VerificationRequest:
                let verificationRequest = message as! VerificationRequest
                self.handleVerificationRequest(verificationRequest: verificationRequest)

            case is SigningRequest:
                let signingRequest = message as! SigningRequest
                print("Received signing request: \(signingRequest.id())")
                self.handleSigningRequest(signingRequest: signingRequest)

            default:
                print("🎯 ContentView: ❓ Unknown message type: \(type(of: message))")
                break
            }
        }

        account.setOnResponseListener { message in
            print("setOnResponseListener: \(message)")
            switch message {
            case is CredentialResponse:
                let response = message as! CredentialResponse

            default:
                print("🎯 ContentView: ❓ Unknown message type: \(type(of: message))")
                break;
            }
        }
        
        /*guard let account = initializedAccount else {
            print("🎯 ContentView: ⚠️ Cannot setup message listener - no account available")
            return
        }
        
        print("🎯 ContentView: 📚 Setting up message listener...")
        
        // Set up request listener for credential and verification requests
        account.setOnRequestListener { request in
            Task { @MainActor in
                handleIncomingRequest(request)
            }
        }
        
        // Also set up message listener for other message types
        account.setOnMessageListener { message in
            Task { @MainActor in
                handleIncomingMessage(message)
            }
        }*/
        
        print("🎯 MainViewModel: ✅ Message listeners configured successfully")
    } */
    
    // transform credential into credential item to perform identifiable to display inside a List
    @Published var credentialItems: [CredentialItem] = []
    func reloadCredentialItems() {
        Task { @MainActor in
//            credentialItems = account.credentials().map { credential in
//                CredentialItem(claims: credential.claims())
//            }
        }
    }
    
    func registerAccount(completion: ((Bool) -> Void)? = nil) {
//        SelfSDK.showLiveness(account: account, showIntroduction: true, autoDismiss: true, onResult: { selfieImageData, credentials, error in
//            print("showLivenessCheck credentials: \(credentials)")
//            self.register(selfieImageData: selfieImageData, credentials: credentials) { success in
//                Task { @MainActor in
//                    completion?(success)
//                }
//            }
//        })
    }
    
    func handleAuthData(data: Data, completion: ((Error?) -> Void)? = nil) {
//        Task(priority: .background) {
//            do {
//                let discoveryData = try await Account.qrCode(data: data)
//                print("Discovery Data: \(discoveryData)")
//                self.serverAddress = discoveryData?.address
//                try await account.connectWith(qrCode: data)
//                Task { @MainActor in
//                    completion?(nil)
//                }
//            } catch {
//                print("Handle data error: \(error)")
//                Task { @MainActor in
//                    completion?(error)
//                }
//            }
//        }
    }
    
    func handleSigningRequest(signingRequest: SigningRequest) {
        
    }
    
//    func respondToSigningRequest(signingRequest: SigningRequest, status: ResponseStatus, credentials: [Credential]) {
//        print("respondToSigningRequest: \(signingRequest.id()) -> status: \(status)")
//        
//        let signingResponse = SigningResponse.Builder()
//            .withRequestId(signingRequest.id())
//            .toIdentifier(signingRequest.toIdentifier())
//            .fromIdentifier(signingRequest.fromIdentifier())
//            .withStatus(status)
//            .withCredentials(credentials)
//            .build()
//
//        self.sendKMPMessage(message: signingResponse) { messageId, error in
//            print("sent signing response with id: \(messageId) error: \(error)")
//        }
//    }
    
    private func handleIncomingMessage(_ message: ChatMessage) {
        print("🎯 ContentView: 📥 Received incoming message of type: \(type(of: message))")
//        let messageContent = chatMessage.message()
//        let fromAddress = chatMessage.fromIdentifier()
//        print("🎯 ContentView: 💬 Chat message from
//              
//        if let chatMessage = message as? ChatMessage {
//            handleIncomingChatMessage(chatMessage)
//        } else if let credentialMessage = message as? CredentialMessage {
//            self.handleIncomingCredentialMessage(credentialMessage)
//            
//        } else {
//            print("🎯 ContentView: ❓ Unknown message type: \(type(of: message))")
//        }
    }
    
    private func handleIncomingCredentialMessage(_ credentialMessage: CredentialMessage) {
//        let messageContent = credentialMessage.credentials()
//        let fromAddress = credentialMessage.fromIdentifier()
//        
//        print("🎯 ContentView: 💬 Credential message from \(fromAddress): '\(messageContent)'")
        // Chat messages are informational, no specific action needed
//        withAnimation(.easeInOut(duration: 0.5)) {
//            currentScreen = .getCustomCredentialResult(success: true)
//        }
    }
    
    private func handleVerificationRequest(verificationRequest: VerificationRequest) {
//        let fromAddress = verificationRequest.fromIdentifier()
//        print("🎯 MainViewModel: 🎫 Verification request from \(fromAddress)")
//        currentVerificationRequest = verificationRequest
        
        // FIXME: Currently, we just assumed that the verification is document signing request
        self.notifyAppScreen(screen: .docSignStart)
    }

    private func handleCredentialRequest(credentialRequest: CredentialRequest) {
//        let fromAddress = credentialRequest.fromIdentifier()
//        print("🎯 MainViewModel: 🎫 Credential request from \(fromAddress)")
        currentCredentialRequest = credentialRequest
        
//        let emailCredential = credentialRequest.details().first?.types().contains(CredentialType.Email) ?? false
//        let documentCredential = credentialRequest.details().first?.types().contains(CredentialType.Passport) ?? false
//        let customCredential = credentialRequest.details().first?.types().contains("CustomerCredential") ?? false
//        
//        if emailCredential {
//            self.notifyAppScreen(screen: .shareEmailStart)
//        } else if documentCredential {
//            self.notifyAppScreen(screen: .shareDocumentStart)
//        } else if customCredential {
//            self.notifyAppScreen(screen: .shareCredentialCustomStart)
//        }else {
//            self.notifyAppScreen(screen: .authStart)
//        }
    }
    
    private func notifyAppScreen(screen: AppScreen) {
        Task { @MainActor in
            appScreen = screen
        }
    }
    
//    func respondToVerificationRequest(verificationRequest: VerificationRequest?, status: ResponseStatus, credentials: [Credential] = [], completion: ((String, Error?) -> Void)? = nil) {
//        print("respondToVerificationRequest: \(verificationRequest?.id()) -> status: \(status)")
//        
//        var temp = verificationRequest
//        if temp == nil {
//            temp = currentVerificationRequest
//        }
//        
//        guard let verificationRequest = temp else {
//            print("📄 MainViewModel: ❌ Cannot send verification response - no stored verification request")
//            return
//        }
//        
//        let verificationResponse = VerificationResponse.Builder()
//            .withRequestId(verificationRequest.id())
//            .toIdentifier(verificationRequest.toIdentifier())
//            .fromIdentifier(verificationRequest.fromIdentifier())
//            .withTypes(verificationRequest.types())
//            .withStatus(status)
//            .withCredentials(credentials)
//            .build()
//
//        self.sendKMPMessage(message: verificationResponse) { messageId, error in
//            print("sent verification response with id: \(messageId) error: \(error)")
//            Task { @MainActor in
//                completion?(messageId, error)
//            }
//        }
//    }
    
    func lfcFlow() {
//        SelfSDK.showLiveness(account: account, showIntroduction: true, autoDismiss: true, onResult: { selfieImageData, credentials, error in
//            print("showLivenessCheck credentials: \(credentials)")
//            //self.register(selfieImageData: selfieImageData, credentials: credentials)
//        })
    }
    
//    private func register(selfieImageData: Data, credentials: [Credential], completion: ((Bool) -> Void)? = nil) {
//        Task(priority: .background) {
//            do {
//                let success = try await account.register(selfieImage: selfieImageData, credentials: credentials)
//                print("Register account: \(success)")
//                completion?(success)
//            } catch let error {
//                print("Register Error: \(error)")
//                completion?(false)
//            }
//        }
//    }
    
    // MARK: - Server connection
    func connectToSelfServer(serverAddress: String, completion: @escaping((Bool) -> Void)) async {
        print("🌐 ServerConnectionProcessing: Connecting to Self server with address: \(serverAddress)")
        self.serverAddress = serverAddress
        
        // Check if we already timed out
        if !isConnecting {
            print("🌐 ServerConnectionProcessing: Connection attempt cancelled due to timeout")
            return
        }
        
        do {
//            let connectionResult = try await account.connectWith(address: serverAddress, info: [:])

            DispatchQueue.main.async {
                // Only proceed if we haven't timed out
                if self.isConnecting {
//                    print("🌐 ServerConnectionProcessing: ✅ Successfully connected to server")
//                    print("🌐 ServerConnectionProcessing: Connection result: \(connectionResult)")

                    //currentStep = 4 // Completed
                    self.isConnecting = false

                    // Wait a moment to show completion, then navigate
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                      //  onConnectionComplete()
                        completion(true)
                    }
                }
            }

        } catch {
            print("🌐 ServerConnectionProcessing: ❌ Failed to connect to server: \(error)")

            DispatchQueue.main.async {
                // Only set error if we haven't already timed out
                if self.isConnecting {
                    self.connectionError = "Failed to connect: \(error.localizedDescription)"
                    self.isConnecting = false
                }
            }
        }
    }
    
    func notifyServerForRequest(message: String, completion: @escaping((String, Error?) -> Void)) {
        guard let serverAddress = serverAddress else {
            print("serverAddress is nil.")
            return
        }
        
        print("serverAddress: \(serverAddress)")
        print("withMessage: \(message)")
        guard let fromPK = account.generateAddress() else {
            print("Failed to generate address.")
            return
        }
        
        let chatMessage = ChatMessage.Builder()
            .toAddress(PublicKey(rawValue: serverAddress))
            .fromAddress(fromPK)
            .withMessage(message)
            .build()

        // send chat to server
        self.sendKMPMessage(message: chatMessage) { messageId, error in
            completion(messageId, error)
        }
    }
    
    func sendKMPMessage(message: Message, completion: ((_ messageId: String, _ error: Error?) -> ())? = nil) {
        Task(priority: .background, operation: {
//            try await self.account.send(message: message, onAcknowledgement: {msgId, error in
//                print("message sent: \(msgId)")
//                if let error = error {
//                    print("🔐 MainViewModel ❌ message send failed: \(error)")
//                } else {
//                    print("🔐 MainViewModel: ✅ message sent successfully with ID: \(msgId)")
//                    // Message sent successfully, now waiting for server response via message listener
//                }
//                completion?(msgId, error)
//            })
        })
    }
    
    func responseToCredentialRequest(credentialRequest: CredentialRequest? = nil, responseStatus: ResponseStatus, completion: ((String, Error?) -> Void)? = nil) {
        print("responseToCredentialRequest: \(credentialRequest?.id())")
        var temp = credentialRequest
        if temp == nil {
            temp = currentCredentialRequest
        }
        
        guard let credentialRequest = temp else {
            print("🔐 MainViewModel: ❌ Cannot send credential response - no stored credential request")
            return
        }
        
        
//        let storedCredentials = account.lookUpCredentials(claims: credentialRequest.details())
//        
//        let credentialResponse = CredentialResponse.Builder()
//            .withRequestId(credentialRequest.id())
//            .withTypes(credentialRequest.types())
//            .toIdentifier(credentialRequest.toIdentifier())
//            .withStatus(responseStatus)
//            .withCredentials(storedCredentials)
//            .build()
//        self.sendKMPMessage(message: credentialResponse) { messageId, error in
//            Task { @MainActor in
//                completion?(messageId, error)
//            }
//        }
    }
    
    func saveServerConnected(isConnected: Bool) {
        // UserDefaults are app-sandboxed and automatically cleared on app uninstall
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isServerConnected)
    }
    
    func getServerConnected() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.isServerConnected)
    }
    
    func saveServerAddress(serverAddress: String) {
        // UserDefaults are app-sandboxed and automatically cleared on app uninstall
        UserDefaults.standard.set(serverAddress, forKey: UserDefaultKeys.connectedServerAddress)
    }
    
    func getServerAddress() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.connectedServerAddress)
    }
    
    func resetUserDefaults() {
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isServerConnected)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.connectedServerAddress)
    }
    
    // MARK: - Backup & Restore
    func backup(completion: ((URL?) -> Void)? = nil) {
        Task (priority: .background) {
//            guard let backupFile = await account.backup() else {
//                completion?(nil)
//                return
//            }
//            print("Backup file: \(backupFile)")
//            Task { @MainActor in
//                completion?(backupFile)
//            }
        }
    }
    
    
    func restore(selfieData: Data, backupFile: URL, completion: ((Bool) -> Void)? = nil) {
        Task (priority: .background) {
//            do {
//                let credentials = try await account.restore(backupFile: backupFile, selfieImage: selfieData)
//                print("Restore complete with error: \(credentials.count)")
//                if credentials.count > 0  {
//                    // register sandbox if needed
//                    Task { @MainActor in
//                        completion?(true)
//                    }
//                } else {
//                    Task { @MainActor in
//                        completion?(false)
//                    }
//                }
//            } catch {
//                
//            }
            
        }
    }
    
    func accountIsRegistered() -> Bool {
        return account.registered()
    }
}

extension FileManager {
    static var storagePath: String {
        let storagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("account1")
        createFolderAtURL(url: storagePath) // create folder if needed
        print("StoragePath: \(storagePath)")
        return storagePath.path()
    }
    
    static func createFolderAtURL(url: URL) {
        if FileManager.default.fileExists(atPath: url.path()) {
            print("Folder already exists: \(url)")
            
        } else {
            // Create the folder
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("Folder created successfully: \(url)")
            } catch {
                print("Error creating folder: \(error.localizedDescription)")
            }
        }
    }
}

