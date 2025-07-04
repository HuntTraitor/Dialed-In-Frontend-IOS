//
//  frontendApp.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//


import SwiftUI
import SimpleKeychain

@main
struct MyApp: App {
    
    init() {
        if CommandLine.arguments.contains("--reset-keychain") {
            let keychain = SimpleKeychain()
            try? keychain.deleteItem(forKey: "auth_session")
        }
    }
    
    @StateObject private var authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
