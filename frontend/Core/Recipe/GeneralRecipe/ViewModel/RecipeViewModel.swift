//
//  RecipeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

@MainActor
class RecipeViewModel<Service: RecipeService>: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var allRecipes: [Recipe] = []

    let recipeService: Service

    init(recipeService: Service) {
        self.recipeService = recipeService
    }

    func fetchAllRecipesAsJSON(withToken token: String) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let result = try await recipeService.fetchAllRecipesAsJSON(withToken: token)
            self.allRecipes = result
        } catch {
            errorMessage = "Failed to fetch all recipes: \(error.localizedDescription)"
        }
    }
}


