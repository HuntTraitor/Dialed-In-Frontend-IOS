//
//  DefaultSwitchRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

import Foundation

final class DefaultSwitchRecipeService: SwitchRecipeService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws -> FetchSwitchRecipeResult {
        var components = URLComponents(url: baseURL.appendingPathComponent("recipes"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "method_id", value: "\(methodId)")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
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
                    print("Verification failed with response: \(json)")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let decoded = try? decoder.decode(MultiSwitchRecipeResponse.self, from: data) {
                return .recipes(decoded.recipes)
            }
            
            if let errorJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return .error(errorJSON)
            }
            
            throw APIError.jsonParsingFailure(error: NSError(domain: "Invalid response format", code: 0))
            
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws -> PostSwitchRecipeResult {
        let url = baseURL.appendingPathComponent("recipes")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(recipe)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No Valid Http Request")
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    return .error(json)
                } else {
                    throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
                }
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let decoded = try? decoder.decode(SingleSwitchRecipeResponse.self, from: data) {
                return .recipe(decoded.recipe)
            }
            
            if let errorJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return .error(errorJSON)
            }
            
            throw APIError.jsonParsingFailure(error: NSError(domain: "Invalid response format", code: 0))

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    
}

