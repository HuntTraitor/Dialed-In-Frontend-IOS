//
//  BaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

protocol RecipeService {
    func fetchAllRecipesAsJSON(withToken token: String) async throws -> [Recipe]
}
