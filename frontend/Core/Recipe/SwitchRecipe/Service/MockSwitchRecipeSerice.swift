//
//  MockSwitchRecipeSerice.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

final class MockSwitchRecipeSerice: MockRecipeService, SwitchRecipeService {
    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws -> [SwitchRecipe] {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else if methodId != Method.MOCK_METHOD.id {
            throw APIError.invalidStatusCode(statusCode: 404)
        } else {
            return SwitchRecipe.MOCK_SWITCH_RECIPES
        }
    }
    
    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws -> SwitchRecipe {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return SwitchRecipe.MOCK_SWITCH_RECIPE
        }
    }
}
