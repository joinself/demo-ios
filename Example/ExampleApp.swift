//
//  ExampleApp.swift
//  Example
//
//  Created by Long Pham on 8/5/25.
//

import SwiftUI
import self_ios_sdk
import ui_components

@main
struct ExampleApp: App {
    
    @ObservedObject var viewModel: MainViewModel = MainViewModel()
    @SwiftUI.Environment(\.scenePhase) private var scenePhase
    
    init () {
        SelfSDK.initialize {
            return "FILL_YOUR_PUSH_TOKEN_HERE"
        } log: { log in
            print("Log: \(log)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        print("App is active")
                    case .inactive:
                        print("App is inactive")
                    case .background:
                        print("App moved to background")
                    @unknown default:
                        print("Unexpected new phase")
                    }
                }
    }
}
