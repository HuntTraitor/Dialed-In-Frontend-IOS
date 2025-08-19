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
    @StateObject private var methodViewModel = MethodViewModel(methodService: DefaultMethodService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var coffeeViewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var recipeViewModel = RecipeViewModel(recipeService: DefaultRecipeService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var navigationManager = NavigationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .environmentObject(authViewModel)
                .environmentObject(methodViewModel)
                .environmentObject(coffeeViewModel)
                .environmentObject(recipeViewModel)
                .preferredColorScheme(.light)
        }
    }
}
