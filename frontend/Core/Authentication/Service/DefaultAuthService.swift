//
//  DefaultAuthService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class DefaultAuthService: AuthService {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // signIn returns a token identifying the user
    func signIn(withEmail email: String, password: String) async throws -> SignInResult {
        let url = baseURL.appendingPathComponent("tokens/authentication")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(requestBody)
        
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
            
            if let decoded = try? JSONDecoder().decode(AuthenticationTokenResponse.self, from: data) {
                return .token(decoded.authenticationToken)
            }
            
            // If decoding Token fails, try decoding an error
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
    
    // createUser creates a new user returning a user object
    func createUser(withEmail email: String, password: String, name: String) async throws -> CreateUserResult {
        let url = baseURL.appendingPathComponent("users")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["name": name, "email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(requestBody)
        
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
            
            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
                return .user(decoded.user)
            } catch {
                throw APIError.jsonParsingFailure(error: error)
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
        
    }
    
    // vertifyUser checks if the users token is valid and returns either true or false
    func verifyUser(withToken token: String) async throws -> User {
        let url = baseURL.appendingPathComponent("users/verify")
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

            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
                return decoded.user
            } catch {
                throw APIError.jsonParsingFailure(error: error)
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
}

