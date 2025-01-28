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
    @EnvironmentObject var methodModel: MethodViewModel
    @Bindable private var navigator = NavigationManager.nav
    
    var body: some View {
        Group {
            if keychainManager.getToken() == "" {
                 LoginView()
             } else {
                 TabView(selection: navigator.tabHandler) {
                     HomeView()
                         .tabItem {
                             Label("Home", systemImage: "house.fill")
                         }
                         .tag(1)
                     
                     SettingsView()
                         .tabItem {
                             Label("Settings", systemImage: "gear")
                         }
                         .tag(2)
                 }
             }
        }
        .onAppear {
            // Print the token when the view appears
            print("Token: \(keychainManager.getToken())")
        }
    }
}

extension View {
    
    //addToolbar
    func addToolbar() -> some View {
        self
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text("Dialed-In")
                            .font(.custom("Cochin-BoldItalic", size: 28))
                            .foregroundColor(.black)
                            .opacity(0.75)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    //addNavigationSupport
    func addNavigationSupport() -> some View {
        self
            .navigationDestination(for: NavigationDestination.self) { destination in
            destination // The enum itself returns the view
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        @StateObject var keychainManager = KeychainManager()
        @StateObject var methodModel = MethodViewModel()
        ContentView()
            .environmentObject(viewModel)
            .environmentObject(keychainManager)
            .environmentObject(methodModel)
    }
}
