//
//  RecipeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/4/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    func getSwitchRecipes(withToken token: String, methodId: Int) async throws -> [SwitchRecipe] {
        let endpoint = "http://localhost:3000/v1/recipes?method_id=\(methodId)"
        let headers = ["Authorization": "Bearer \(token)"]
        
        let result = try await Get(to: endpoint, with: headers)
        
        print(result)
        
        guard let recipeDicts = result["recipes"] as? [[String?: Any]] else {
            throw CustomError.methodError(message: "Error when parsing Recipes")
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: recipeDicts, options: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let recipes = try decoder.decode([SwitchRecipe].self, from: jsonData)
        return recipes
    }
}

