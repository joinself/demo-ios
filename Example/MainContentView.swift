//
//  ContentView.swift
//  Example
//
//  Created by Long Pham on 8/5/25.
//

import SwiftUI
import self_ios_sdk
import SelfUI

struct MainContentView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var showVerifyDocument: Bool = false
    @State private var showVerifyEmail: Bool = false
    @State private var showQRScanner = false
    @State private var isCodeValid = false
    @State private var isBackingUp = false
    @State private var isRestoring = false
    
    @State private var showDocumentPicker = false
    @State private var selectedFileName: String?
    @State private var selectedFileURLs: [URL] = []
    @State private var fileToShareURLs: [URL] = []
    @State private var showShareSheet = false
    
    @State private var showCaptureLivenessImage = false
    @AppStorage("backupFile") private var backupFile: URL?
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, SelfSDK!")
            
            Button {
                viewModel.registerAccount { success in
                    print("Register account finished: \(success)")
                    viewModel.accountRegistered = success
                }
            } label: {
                Text("Register Account")
            }
            .disabled(viewModel.accountRegistered)
            .buttonStyle(.borderedProminent)
            
            Button {
                viewModel.lfcFlow()
            } label: {
                Text("LFC Flow")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                showVerifyDocument = true
            } label: {
                Text("Verify Document Flow")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                showVerifyEmail = true
            } label: {
                Text("Verify Email Flow")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                SelfSDK.verifyEmail(account: viewModel.account, transitionAsModal: true) { success in
                    print("Verify email finished: \(success)")
                    if success {
                        self.viewModel.reloadCredentialItems()
                    }
                }
            } label: {
                Text("Verify Email Without Prompt Flow")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                showQRScanner = true
            } label: {
                Text("Show QR Scanner View")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                isBackingUp = true
                viewModel.backup { url in
                    isBackingUp = false
                    backupFile = url
                    if let url = url {
                        fileToShareURLs = [url]
                        // share backup file
                        showShareSheet = true
                    }
                    
                    
                }
            } label: {
                Text("Backup Account")
            }
            .disabled(isBackingUp)
            .buttonStyle(.borderedProminent)
            
            Button {
                showDocumentPicker = true
                
            } label: {
                Text("Restore Account")
            }
            .disabled(isRestoring)
            .buttonStyle(.borderedProminent)
            List {
                // display credentials here!
                ForEach(viewModel.credentialItems) { credentialItem in
                    if let value = credentialItem.claims.first?.value() {
                        Text(value)
                            .foregroundStyle(Color.white)
                    }
                    
                }
            }

        }
        .fullScreenCover(isPresented: $showVerifyDocument, onDismiss: {
            // dismiss view
        }, content: {
            DocumentFlow(account: viewModel.account, autoCaptureImage: false, onResult:  { success in
                print("Verify document finished: \(success)")
                showVerifyDocument = false
                // reload view to display document's credential
                if success {
                    self.viewModel.reloadCredentialItems()
                }
            })
        })
        .fullScreenCover(isPresented: $showVerifyEmail, onDismiss: {
            
        }, content: {
            EmailFlow(account: viewModel.account, autoDismiss: false, onResult: { success in
                print("Verify email finished = \(success)")
                self.showVerifyEmail = false
                if success {
                    self.viewModel.reloadCredentialItems()
                }
            })
        })
        .fullScreenCover(isPresented: $showQRScanner, onDismiss: {
            
        }, content: {
            QRReaderView(isCodeValid: $isCodeValid, onCode: { code in
                print("QRCode: \(code)")
            }) { codeData in
                print("QRCode: \(codeData)")
                viewModel.handleAuthData(data: codeData) { error in
                    if error == nil {
                        showQRScanner = false
                    }
                }
            }
        })
        .onChange(of: self.selectedFileURLs, perform: { newValue in
            print("Files change: \(newValue)")
            if let url = newValue.first, url.pathExtension == "self_backup" {
                // handle restore account
                backupFile = url
                guard let backupFile = backupFile else {
                    return
                }
                
                if url.startAccessingSecurityScopedResource() {
                    print("startAccessingSecurityScopedResource")
                }
                
                // 1. Do liveness to get liveness's selfie image
                SelfSDK.showLiveness(account: viewModel.account, showIntroduction: true, autoDismiss: true, isVerificationRequired: false, onResult: { selfieImageData, credentials, error in
                    print("showLivenessCheck credentials: \(credentials)")
                    isRestoring = true
                    viewModel.restore(selfieData: selfieImageData, backupFile: backupFile) { success in
                        print("Restore account finished: \(success)")
                        isRestoring = false
                    }
                })
            }
        })
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(selectedFileName: $selectedFileName, selectedFileURLs: $selectedFileURLs)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: fileToShareURLs) {
                self.showShareSheet = false
            }
        }
        .padding()
    }
}
