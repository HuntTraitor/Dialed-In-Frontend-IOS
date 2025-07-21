//
//  BaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

protocol RecipeService {
    func fetchRecipes(withToken token: String) async throws -> [Recipe]
    func postRecipe(withToken token: String, recipe: Recipe) async throws -> Recipe
}
