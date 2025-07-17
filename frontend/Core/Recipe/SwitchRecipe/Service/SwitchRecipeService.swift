//
//  SwitchRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

protocol SwitchRecipeService: RecipeService {
    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws -> [SwitchRecipe]
    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws -> SwitchRecipe
}

