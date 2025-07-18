//
//  MockBaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

class MockRecipeService: RecipeService {
    var isErrorThrown = false
    func fetchRecipes(withToken token: String, withMethod method: Method?) async throws -> [AnyRecipe] {
        return []
    }
}

