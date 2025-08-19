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
    
    func fetchRecipes(withToken token: String) async throws -> [Recipe] {
        let url = baseURL.appendingPathComponent("recipes")
        
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
                        
            do {
                let decoder = JSONDecoder()                
                let wrapper = try decoder.decode(RecipeWrapper.self, from: data)
                return wrapper.recipes
            } catch let error as DecodingError {
                #if DEBUG
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Raw JSON Response:\n\(jsonString)")
                }
                #endif
                
                switch error {
                case .dataCorrupted(let context):
                    print("""
                    🛑 Data corrupted:
                    - Context: \(context.debugDescription)
                    - Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))
                    - Underlying Error: \(context.underlyingError?.localizedDescription ?? "none")
                    """)
                    
                case .keyNotFound(let key, let context):
                    print("""
                    🔑 Key not found:
                    - Missing Key: \(key.stringValue)
                    - Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))
                    - Debug Description: \(context.debugDescription)
                    - Full Path: \(context.codingPath)
                    """)
                    
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let recipes = json["recipes"] as? [[String: Any]] {
                        print("ℹ️ First recipe keys:", recipes.first?.keys ?? "No recipes")
                    }
                    
                case .valueNotFound(let type, let context):
                    print("""
                    ❌ Value not found:
                    - Expected Type: \(type)
                    - Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))
                    - Debug Description: \(context.debugDescription)
                    """)
                    
                case .typeMismatch(let type, let context):
                    print("""
                    ↔️ Type mismatch:
                    - Expected Type: \(type)
                    - Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))
                    - Debug Description: \(context.debugDescription)
                    """)
                    
                @unknown default:
                    print("❓ Unknown decoding error:", error.localizedDescription)
                }
                
                throw APIError.jsonParsingFailure(error: error)
            } catch {
                print("⚠️ Unexpected error:", error.localizedDescription)
                throw APIError.jsonParsingFailure(error: error)
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func postRecipe<T: RecipeInput>(withToken token: String, recipe: T) async throws -> Recipe {
        let url = baseURL.appendingPathComponent("recipes")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        request.httpBody = try encoder.encode(recipe)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Upload failed with response: \(json)")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(SingleGenericRecipeResponse.self, from: data)
            return result.recipe

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func editRecipe<T: RecipeInput>(withToken token: String, recipe: T, recipeId: Int) async throws -> Recipe {
        let url = baseURL.appendingPathComponent("recipes/\(recipeId)")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        request.httpBody = try encoder.encode(recipe)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Upload failed with response: \(json)")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(SingleGenericRecipeResponse.self, from: data)
            return result.recipe

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    struct SingleGenericRecipeResponse: Decodable {
        let recipe: Recipe
    }
    
    private struct RecipeWrapper: Decodable {
        let recipes: [Recipe]
    }
}
