//
//  SwitchRecipeViewModelTests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/1/25.
//

import Testing
@testable import DialedIn

@MainActor
struct SwitchRecipeViewModelTests {
    @Test func fetching_switch_recipes_is_successful() async throws {
        let recipeService = MockSwitchRecipeSerice()
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.fetchSwitchRecipes(withToken: Token.MOCK_TOKEN.token, methodId: Method.MOCK_METHOD.id)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.recipes == SwitchRecipe.MOCK_SWITCH_RECIPES)
    }
    
    @Test func fecthing_switch_recipes_with_unknown_methodId_errors() async throws {
        let recipeService = MockSwitchRecipeSerice()
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.fetchSwitchRecipes(withToken: Token.MOCK_TOKEN.token, methodId: 999)
        #expect(((viewModel.errorMessage?.contains("404")) != nil))
        #expect(viewModel.recipes.isEmpty)
    }
    
    @Test func fetching_switch_recipes_with_unknown_token_errors() async throws {
        let recipeService = MockSwitchRecipeSerice()
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.fetchSwitchRecipes(withToken: "badToken", methodId: Method.MOCK_METHOD.id)
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
        #expect(viewModel.recipes.isEmpty)
    }
    
    @Test func fetching_switch_recipes_with_uknown_error_errors() async throws {
        let recipeService = MockSwitchRecipeSerice()
        recipeService.isErrorThrown = true
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.fetchSwitchRecipes(withToken: Token.MOCK_TOKEN.token, methodId: Method.MOCK_METHOD.id)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.recipes.isEmpty)
    }
    
    @Test func post_switch_recipe_is_successful() async throws {
        let recipeService = MockSwitchRecipeSerice()
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.postSwitchRecipe(withToken: Token.MOCK_TOKEN.token, recipe: SwitchRecipe.MOCK_SWITCH_RECIPE_INPUT)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.recipes == SwitchRecipe.MOCK_SWITCH_RECIPES)
    }
    
    @Test func post_switch_recipes_with_bad_token_errors() async throws {
        let recipeService = MockSwitchRecipeSerice()
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.postSwitchRecipe(withToken: "badToken", recipe: SwitchRecipe.MOCK_SWITCH_RECIPE_INPUT)
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
        #expect(viewModel.recipes.isEmpty)
    }
    
    @Test func post_switch_recipes_with_unexpected_error_errors() async throws {
        let recipeService = MockSwitchRecipeSerice()
        recipeService.isErrorThrown = true
        let viewModel = SwitchRecipeViewModel(recipeService: recipeService)
        try await viewModel.postSwitchRecipe(withToken: Token.MOCK_TOKEN.token, recipe: SwitchRecipe.MOCK_SWITCH_RECIPE_INPUT)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.recipes.isEmpty)
    }
}

