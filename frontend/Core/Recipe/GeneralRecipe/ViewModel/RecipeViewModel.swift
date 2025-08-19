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
            self.switchRecipes = fetched.compactMap { recipe in
                if case let .switchRecipe(switchRecipe) = recipe {
                    return switchRecipe
                }
                return nil
            }
        } catch {
            errorMessage = "Failed to fetch all recipes: \(error.localizedDescription)"
        }
    }
    
    func postRecipe<T: RecipeInput>(withToken token: String, recipe: T) async {
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
    
    func editRecipe<T: RecipeInput>(withToken token: String, recipe: T, recipeId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let recipe = try await recipeService.editRecipe(withToken: token, recipe: recipe, recipeId: recipeId)
            await fetchRecipes(withToken: token)
        } catch {
            errorMessage = "Failed to edit recipe: \(error.localizedDescription)"
        }
        isLoading = false
    }
}


