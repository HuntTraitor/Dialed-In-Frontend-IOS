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
    @State var methodViewModel = MethodViewModel()
    @StateObject var coffeeViewModel = CoffeeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(keychainManager)
                .environmentObject(methodViewModel)
                .environmentObject(coffeeViewModel)
        }
    }
}
