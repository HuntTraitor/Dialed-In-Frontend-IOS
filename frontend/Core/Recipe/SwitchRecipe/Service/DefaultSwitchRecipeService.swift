//
//  DefaultSwitchRecipeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

import Foundation

final class DefaultSwitchRecipeService: DefaultRecipeService, SwitchRecipeService {
    override init(baseURL: URL) {
        super.init(baseURL: baseURL)
    }

    func fetchSwitchRecipes(withToken token: String, methodId: Int) async throws -> [SwitchRecipe] {
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
                print(httpResponse.statusCode)
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Verification failed with response: \(json)")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return try decoder.decode(MultiSwitchRecipeResponse.self, from: data).recipes

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }

    func postSwitchRecipe(withToken token: String, recipe: SwitchRecipeInput) async throws -> SwitchRecipe {
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

            return try decoder.decode(SingleSwitchRecipeResponse.self, from: data).recipe

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
}


