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
    }
}
