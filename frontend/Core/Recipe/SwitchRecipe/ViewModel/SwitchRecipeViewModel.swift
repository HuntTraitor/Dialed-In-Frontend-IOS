//
//  RecipeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/4/25.
//

//import Foundation
//
//@MainActor
//class SwitchRecipeViewModel<Service: SwitchRecipeService>: RecipeViewModel<Service> {
//    @Published var switchRecipes: [SwitchRecipe] = []
//
//    func fetchSwitchRecipes(withToken token: String, methodId: Int) async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            let fetched = try await recipeService.fetchSwitchRecipes(withToken: token, methodId: methodId)
//            self.switchRecipes = fetched
//        } catch {
//            errorMessage = "Failed to fetch recipes: \(error.localizedDescription)"
//        }
//        isLoading = false
//    }
//
//    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            _ = try await recipeService.postSwitchRecipe(withToken: token, recipe: recipe)
//            await fetchSwitchRecipes(withToken: token, methodId: recipe.methodId)
//        } catch {
//            errorMessage = "Failed to post recipe: \(error.localizedDescription)"
//        }
//        isLoading = false
//    }
//}


