//
//  RecipeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/4/25.
//

import Foundation

class SwitchRecipeViewModel: ObservableObject {
    @Published var recipes: [SwitchRecipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let recipeService: SwitchRecipeService
    
    init(recipeService: SwitchRecipeService) {
        self.recipeService = recipeService
    }
    
    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await recipeService.fetchSwitchRecipes(withToken: token, methodId: methodId)
            switch result {
            case .recipes(let recipes):
                self.recipes = recipes
            case .error(let errorDict):
                errorMessage = errorDict["error"] as? String
            }
        } catch {
            errorMessage = "Failed to fetch recipes: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await recipeService.postSwitchRecipe(withToken: token, recipe: recipe)
            switch result {
            case .recipe:
                try await fetchSwitchRecipes(withToken: token, methodId: recipe.methodId)
            case .error(let errorDict):
                errorMessage = errorDict["error"] as? String
            }
        } catch {
            errorMessage = "Failed to post recipe \(error.localizedDescription)"
        }
        isLoading = false
    }
}

