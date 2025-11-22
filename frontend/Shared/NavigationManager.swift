//
//  NavigationManager.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

// Define a singleton class for managing navigation

import SwiftUI

enum RecipesRoute: Hashable {
    case all
    case create
    case switchRecipe(SwitchRecipe)
    case v60Recipe(V60Recipe)
}

final class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var selectedTab = 1
    @Published var homeNavigator: [NavigationDestination] = []
    @Published var coffeeNavigator: [NavigationDestination] = []
    @Published var recipesNavigator: [RecipesRoute] = []
    @Published var settingsNavigator: [NavigationDestination] = []
    
    var tabHandler: Binding<Int> {
        Binding(
            get: { self.selectedTab },
            set: {
                if $0 == self.selectedTab {
                    switch $0 {
                    case 1: self.homeNavigator = []
                    case 2: self.coffeeNavigator = []
                    case 3: self.recipesNavigator = []
                    case 4: self.settingsNavigator = []
                    default: self.homeNavigator = []
                    }
                }
                self.selectedTab = $0
            }
        )
    }
    private init() {}
}

extension View {
    func recipesNavigationSupport() -> some View {
        self
            .navigationDestination(for: RecipesRoute.self) { route in
                switch route {
                case .all:
                    AllRecipeView()
                case .create:
                    CreateAnyRecipeView()
                case .switchRecipe(let recipe):
                    SwitchRecipeView(recipe: recipe)
                case .v60Recipe(let recipe):
                    V60RecipeView(recipe: recipe)
                }
            }
    }
}

