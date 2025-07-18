//
//  BaseRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

class DefaultRecipeService: RecipeService {
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // We should create a forMethod parameter that is optional that will query parameter the method
    func fetchRecipes(withToken token: String, withMethod method: Method?) async throws -> [AnyRecipe] {
        var url = baseURL.appendingPathComponent("recipes")
        
        if let method = method {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [
                URLQueryItem(name: "method_id", value: "\(method.id)")
            ]
            if let composedURL = components?.url {
                url = composedURL
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Fetch all failed with response: \(json)")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }
            
            // Print raw JSON for debugging
            print("Raw response data:", String(data: data, encoding: .utf8) ?? "Unable to print data")
            let recipes: [AnyRecipe]
            
            do {
                
                // decode using model depending on the method
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                
                if let method = method {
                    switch method.type {
                    case .harioSwitch:
                        let wrapper = try decoder.decode(MultiSwitchRecipeResponse.self, from: data)
                        recipes = wrapper.recipes.map { .switchRecipe($0) }
                    default:
                        let wrapper = try decoder.decode(RecipeWrapper.self, from: data)
                        recipes = wrapper.recipes.map { .generic($0) }
                    }
                } else {
                    let wrapper = try decoder.decode(RecipeWrapper.self, from: data)
                    recipes = wrapper.recipes.map { .generic($0) }
                }
            } catch {
                print("Decoding failed with error:", error)
                throw APIError.jsonParsingFailure(error: error)
            }

            return recipes
            
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    private struct RecipeWrapper: Decodable {
        let recipes: [Recipe]
    }
}
