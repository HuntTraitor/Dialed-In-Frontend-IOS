//
//  RecipeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/4/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var switchRecipes: [SwitchRecipe] = []
    
    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws {
        do {
            let endpoint = "http://localhost:3000/v1/recipes?method_id=\(methodId)"
            let headers = ["Authorization": "Bearer \(token)"]
            
            let result = try await Get(to: endpoint, with: headers)
            guard let recipeDicts = result["recipes"] as? [[String?: Any]] else {
                throw CustomError.methodError(message: "Error when parsing Recipes")
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: recipeDicts, options: [])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipes = try decoder.decode([SwitchRecipe].self, from: jsonData)
            await MainActor.run {
                self.switchRecipes = recipes
            }
        }
    }
    
    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws {
        guard let url = URL(string: "http://localhost:3000/v1/recipes") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(recipe)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("Server responded with: \(responseBody)")
            throw CustomError.methodError(message: "Failed to upload recipe")
        }
        
        print("Recipe uploaded successfully")
    }
}

