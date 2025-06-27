//
//  SwitchRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

protocol SwitchRecipeService {
    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws -> FetchSwitchRecipeResult
    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws -> PostSwitchRecipeResult
}

