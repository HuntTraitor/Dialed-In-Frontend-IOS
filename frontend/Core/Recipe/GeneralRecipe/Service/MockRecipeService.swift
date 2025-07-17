//
//  MockBaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

class MockRecipeService: RecipeService {
    var isErrorThrown = false
    func fetchAllRecipesAsJSON(withToken token: String) async throws -> [Recipe] {
        return []
    }
}

