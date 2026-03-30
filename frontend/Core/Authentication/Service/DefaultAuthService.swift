//
//  DefaultAuthService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class DefaultAuthService: BaseApiService, AuthService {
    
    func signIn(withEmail email: String, password: String) async throws -> Token {
        let body = try encoded(["email": email, "password": password])
        let request = authorizedRequest(path: "tokens/authentication", method: "POST", token: "", body: body)
        let data = try await perform(request, customValidation: {statusCode in
                switch statusCode {
                case 401: throw APIError.custom(message: "Invalid email or password")
                default: break
            }
        })
        return try decode(AuthenticationTokenResponse.self, from: data).authenticationToken
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws -> User {
        let body = try encoded(["name": name, "email": email, "password": password])
        let request = authorizedRequest(path: "users", method: "POST", token: "", body: body)
        let data = try await perform(request, customValidation: { [weak self] _ in
                
        }, errorParser: { json in
            if let errorDict = json["error"] as? [String:Any] {
                let message = (errorDict["email"] as? String) ?? (errorDict.values.first as? String) ?? ""
                if !message.isEmpty {
                    throw APIError.custom(message: message.prefix(1).uppercased() + message.dropFirst())
                }
            }
        })
        return try decode(UserResponse.self, from: data).user
    }
    
    func verifyUser(withToken token: String) async throws -> User {
        let request = authorizedRequest(path: "users/verify", method: "GET", token: token)
        let data = try await perform(request)
        return try decode(UserResponse.self, from: data).user
    }
    
    func sendPasswordResetEmail(toEmail email: String) async throws -> EmailSentResponse {
        let body = try encoded(["email": email])
        let request = authorizedRequest(path: "tokens/password-reset", method: "POST", token: "", body: body)
        let data = try await perform(request, customValidation: { statusCode in
            if statusCode == 422 { throw APIError.custom(message: "No account found with that email address.")}
        })
        return try decode(EmailSentResponse.self, from: data)
    }
    
    func resetPassword(password: String, code: String) async throws -> PasswordResetResponse {
        let body = try encoded(["password": password, "token": code])
        let request = authorizedRequest(path: "users/password", method: "PUT", token: "", body: body)
        let data = try await perform(request, errorParser: { json in
            if let tokenError = (json["error"] as? [String: String])?["token"] {
                throw APIError.custom(message: tokenError)
            }
        })
        
        return try decode(PasswordResetResponse.self, from: data)
        
    }
    
}
