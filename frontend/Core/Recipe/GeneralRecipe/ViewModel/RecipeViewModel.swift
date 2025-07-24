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
    @Published var allRecipes: [Recipe] = []
    @Published var switchRecipes: [SwitchRecipe] = []

    private let recipeService: RecipeService

    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }

    // why not just have this fetch all recipes and then store it in the switchRecipes variable in a filter
    func fetchRecipes(withToken token: String) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let fetched = try await recipeService.fetchRecipes(withToken: token)
            self.allRecipes = fetched
            self.switchRecipes = fetched.compactMap(mapToSwitchRecipe)
        } catch {
            errorMessage = "Failed to fetch all recipes: \(error.localizedDescription)"
        }
    }
    
    func postRecipe(withToken token: String, recipe: Recipe) async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await recipeService.postRecipe(withToken: token, recipe: recipe)
            await fetchRecipes(withToken: token)
        } catch {
            errorMessage = "Failed to post recipe: \(error.localizedDescription)"
        }
        isLoading = false
    }
}


