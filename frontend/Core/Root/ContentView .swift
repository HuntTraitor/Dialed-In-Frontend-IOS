//
//  ContentView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI
import SimpleKeychain

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isLogoutDialogOpen = false
    @State private var lastValidTab = 1
    @State private var authPath = NavigationPath()

    private let testingID = UIIdentifiers.HomeScreen.self

    var body: some View {
        Group {
            if !authViewModel.hasVerifiedSession {
                ProgressView()
            } else if !authViewModel.isAuthenticated {
                NavigationStack(path: $authPath) {
                    LoginView(
                        onForgotPassword: {
                            authPath.append(AuthRoute.sendEmail)
                        },
                        onRegister: {
                            authPath.append(AuthRoute.register)
                        }
                    )
                    .navigationDestination(for: AuthRoute.self) { route in
                        switch route {
                        case .sendEmail:
                            SendEmailView(path: $authPath)
                        case .resetPassword:
                            PasswordResetView(path: $authPath)
                        case .register:
                            RegistrationView()
                        }
                    }
                }
                // resets tabs when user logs out
                .onAppear {
                    navigationManager.selectedTab = 1
                    navigationManager.homeNavigator = []
                    navigationManager.coffeeNavigator = []
                    navigationManager.recipesNavigator = []
                    navigationManager.settingsNavigator = []
                    authPath = NavigationPath()  // reset auth stack too
                }
            } else {
                TabView(selection: navigationManager.tabHandler) {
                    NavigationStack(path: $navigationManager.homeNavigator) {
                        HomeView()
                    }
                    .appNavigationSupport()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(1)
                    
                    NavigationStack(path: $navigationManager.coffeeNavigator) {
                        CoffeeView()
                    }
                    .appNavigationSupport()
                    .tabItem { Label("Coffee", systemImage: "cup.and.saucer.fill") }
                    .tag(2)
                    
                    NavigationStack(path: $navigationManager.recipesNavigator) {
                        GeneralRecipeView(curMethod: nil)
                    }
                    .appNavigationSupport()
                    .tabItem { Label("Recipes", systemImage: "book.pages") }
                    .tag(3)
                    
                    NavigationStack(path: $navigationManager.settingsNavigator) {
                        ProfileView()
                    }
                    .appNavigationSupport()
                    .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                    .tag(4)
                }
            }
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
    
    //appNavigationSupport
    func appNavigationSupport() -> some View {
        self.navigationDestination(for: NavigationDestination.self) { destination in
            destination
        }
    }
}


#Preview {
    PreviewWrapper {
        ContentView()
            .addToolbar()
    }
}
