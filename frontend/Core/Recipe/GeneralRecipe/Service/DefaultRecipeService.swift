//
//  BaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

final class DefaultRecipeService: BaseApiService, RecipeService {
    
    func fetchRecipes(withToken token: String) async throws -> [Recipe] {
        let request = authorizedRequest(path: "recipes", method: "GET", token: token)
        let data = try await perform(request)
        return try decode(RecipeWrapper.self, from: data).recipes
    }
    
    func postRecipe<T: RecipeInput>(withToken token: String, recipe: T) async throws -> Recipe {
        let request = authorizedRequest(path: "recipes", method: "POST", token: token, body: try encoded(recipe))
        let data = try await perform(request)
        return try decode(SingleGenericRecipeResponse.self, from: data).recipe
        
    }
    
    func editRecipe<T: RecipeInput>(withToken token: String, recipe: T, recipeId: Int) async throws -> Recipe {
        let request = authorizedRequest(path: "recipes/\(recipeId)", method: "PATCH", token: token, body: try encoded(recipe))
        let data = try await perform(request)
        return try decode(SingleGenericRecipeResponse.self, from: data).recipe
    }
    
    func deleteRecipe(recipeId: Int, token: String) async throws -> Bool {
        let request = authorizedRequest(path: "recipes/\(recipeId)", method: "DELETE", token: token)
        _ = try await perform(request)
        return true
    }
}

private extension DefaultRecipeService {
    struct RecipeWrapper: Decodable {
        let recipes: [Recipe]
    }
    
    struct SingleGenericRecipeResponse: Decodable {
        let recipe: Recipe
    }
}
