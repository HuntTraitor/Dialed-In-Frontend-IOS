//
//  DefaultCoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class DefaultCoffeeService: CoffeeService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetchCoffees(withToken token: String) async throws -> FetchCoffeesResult {
        let url = baseURL.appendingPathComponent("coffees")
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
            
            if let decoded = try? JSONDecoder().decode(MultiCoffeeResponse.self, from: data) {
                return .coffees(decoded.coffees)
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
    
    func postCoffee(input: CoffeeInput, token: String) async throws -> PostCoffeeResult {
        let url = baseURL.appendingPathComponent("coffees")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        request.httpBody = input.toMultiPartData(boundary: boundary)
        
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
            
            if let decoded = try? JSONDecoder().decode(SingleCoffeeResponse.self, from: data) {
                return .coffee(decoded.coffee)
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
    
    func deleteCoffee(coffeeId: Int, token: String) async throws -> DeleteCoffeeResult {
        let url = baseURL.appendingPathComponent("coffees/\(coffeeId)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
            
            if let _ = try? JSONDecoder().decode(DeleteCoffeeResponse.self, from: data) {
                return .deleted(true)
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
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> UpdateCoffeeResult {
        let url = baseURL.appendingPathComponent("coffees/\(input.id!)")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        request.httpBody = input.toMultiPartData(boundary: boundary)
        
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
            
            if let decoded = try? JSONDecoder().decode(SingleCoffeeResponse.self, from: data) {
                return .coffee(decoded.coffee)
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
