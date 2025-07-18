//
//  BaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

protocol RecipeService {
    func fetchRecipes(withToken token: String, withMethod method: Method?) async throws -> [AnyRecipe]
}
