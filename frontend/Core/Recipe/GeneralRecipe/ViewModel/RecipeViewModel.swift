//
//  RecipeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var allRecipes: [AnyRecipe] = []

    private let recipeService: RecipeService

    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    // Method specific recipes
    var switchRecipes: [SwitchRecipe] {
        allRecipes.compactMap { recipe in
            if case let .switchRecipe(switchRecipe) = recipe {
                return switchRecipe
            }
            return nil
        }
    }

    func fetchRecipes(withToken token: String, withMethod method: Method?) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let result = try await recipeService.fetchRecipes(withToken: token, withMethod: method)
            self.allRecipes = result
        } catch {
            errorMessage = "Failed to fetch all recipes: \(error.localizedDescription)"
        }
    }
}


