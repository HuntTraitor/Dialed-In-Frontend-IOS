//
//  Auth.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

// DATA FORMAT ---------------------------------------------------------------------------------------------------------
struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let activated: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case createdAt = "created_at"
        case activated
    }
}

struct Token: Codable {
    var token: String
    var expiry: String
}

struct AuthSessionState: Codable {
    let token: Token
    let user: User
}

// RESPONSES & RESULTS ------------------------------------------------------------------------------------------------
struct UserResponse: Codable {
    let user: User
}

struct AuthenticationTokenResponse: Codable {
    let authenticationToken: Token
    
    enum CodingKeys: String, CodingKey {
        case authenticationToken = "authentication_token"
    }
}

enum CreateUserResult {
    case user(User)
    case error([String: Any])
}

enum VerifyUserResponse {
    case user(User)
    case error([String: Any])
}

enum SignInResult {
    case token(Token)
    case error([String: Any])
}

// EXTENSIONS ------------------------------------------------------------------------------------------------------------------------------

extension User {
    static var MOCK_USER = User(id: 1, name: "Hunter Tratar", email: "hunterrrisatratar@gmail.com", createdAt: "2024-12-11T23:04:05Z", activated: false)
}

extension Token {
    static var MOCK_TOKEN = Token(token: "12345678", expiry: "2025-01-10T20:36:21.010464673Z")
}

let emailRX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

enum AuthSessionError: LocalizedError {
    case invalidCredentials
    case emailNotFound
    case accountInactive
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Incorrect email or password. Please try again."
        case .emailNotFound:
            return "We couldn't find an account with that email."
        case .accountInactive:
            return "Your account has not been activated."
        case .unknown(let message):
            return message
        }
    }
}








