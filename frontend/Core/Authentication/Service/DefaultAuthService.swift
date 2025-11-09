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
    
    func signIn(withEmail email: String, password: String) async throws -> Token {
        let url = baseURL.appendingPathComponent("tokens/authentication")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                switch httpResponse.statusCode {
                case 401:
                    throw APIError.custom(message: "Invalid email or password.")
                case 404:
                    throw APIError.custom(message: "We couldn't find an account with that email.")
                default:
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        throw APIError.custom(message: errorMessage)
                    } else {
                        throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
                    }
                }
            }
            if let decoded = try? JSONDecoder().decode(AuthenticationTokenResponse.self, from: data) {
                return decoded.authenticationToken
            } else {
                throw APIError.jsonParsingFailure(error: NSError(domain: "Unable to decode token", code: 0))
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws -> User {
        let url = baseURL.appendingPathComponent("users")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["name": name, "email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorDict = json["error"] as? [String: Any] {
                    
                    if let emailError = errorDict["email"] as? String {
                        throw APIError.custom(message: emailError.prefix(1).capitalized + emailError.dropFirst()) // capitalize first letter
                    } else if let generalError = errorDict.values.first as? String {
                        throw APIError.custom(message: generalError)
                    }
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
            return decoded.user

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }

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
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = json["error"] as? String {
                    throw APIError.custom(message: errorMessage)
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
            return decoded.user

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func sendPasswordResetEmail(toEmail email: String) async throws -> EmailSentResponse {
        let url = baseURL.appendingPathComponent("tokens/password-reset")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["email": email]
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Email sending failed with response: \(json)")
                    if let errorMessage = json["error"] as? String {
                        throw APIError.custom(message: errorMessage)
                    }
                }
                if httpResponse.statusCode == 422 {
                    throw APIError.custom(message: "No account found with that email address.")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }
            
            do {
                let decoded = try JSONDecoder().decode(EmailSentResponse.self, from: data)
                return decoded
            } catch let decodingError as DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type \(type) at \(context.codingPath): \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value of type \(type) not found at \(context.codingPath): \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found at \(context.codingPath): \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted at \(context.codingPath): \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error: \(decodingError)")
                }
                throw APIError.jsonParsingFailure(error: decodingError)
            } catch {
                // For non-DecodingErrors (e.g., data issues)
                print("Unexpected error: \(error)")
                throw APIError.jsonParsingFailure(error: error)
            }
            
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
}

