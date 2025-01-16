//
//  ContentView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI
import SimpleKeychain

struct ContentView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if keychainManager.getToken() == "" {
                 LoginView()
             } else {
                 HomeView()
             }
        }
        .onAppear {
            // Print the token when the view appears
            print("Token: \(keychainManager.getToken())")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        @StateObject var keychainManager = KeychainManager()
        ContentView()
            .environmentObject(viewModel)
            .environmentObject(keychainManager)
    }
}
