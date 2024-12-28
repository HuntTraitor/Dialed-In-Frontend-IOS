//
//  frontendApp.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI
import SimpleKeychain

@main
struct frontendApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject private var keychainManager = KeychainManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(keychainManager)
        }
    }
}
