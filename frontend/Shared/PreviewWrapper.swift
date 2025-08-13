//
//  PreviewWrapper.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/21/25.
//

import SwiftUI

struct PreviewWrapper<Content: View>: View {
    let content: () -> Content

    @StateObject private var authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var methodViewModel = MethodViewModel(methodService: DefaultMethodService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var coffeeViewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var recipeViewModel = RecipeViewModel(recipeService: DefaultRecipeService(baseURL: EnvironmentManager.current.baseURL))
    @StateObject private var navigationManager = NavigationManager.shared

    var body: some View {
        content()
            .environmentObject(authViewModel)
            .environmentObject(methodViewModel)
            .environmentObject(coffeeViewModel)
            .environmentObject(recipeViewModel)
            .environmentObject(navigationManager)
        
    }
}

