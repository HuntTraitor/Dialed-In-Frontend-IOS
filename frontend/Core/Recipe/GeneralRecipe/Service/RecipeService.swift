//
//  BaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

protocol RecipeService {
    func fetchRecipes(withToken token: String) async throws -> [Recipe]
    func postRecipe<T: RecipeInput>(withToken token: String, recipe: T) async throws -> Recipe
    func editRecipe<T: RecipeInput>(withToken token: String, recipe: T, recipeId: Int) async throws -> Recipe
    func deleteRecipe(recipeId: Int, token: String) async throws -> Bool
}
