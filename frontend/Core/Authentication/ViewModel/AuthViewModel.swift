//
//  AuthViewModel.swift
//  frontend
//
//  Created by Hunter Tratar on 12/11/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws -> SignInResult {
        let endpoint = "http://localhost:3000/v1/tokens/authentication"
        let requestBody = ["email": email, "password": password]
        
        let result = try await Post(to: endpoint, with: requestBody)
                
        if let tokenDict = result["authentication_token"] as? [String: Any] {
            let token = try JSONDecoder().decode(Token.self, from: JSONSerialization.data(withJSONObject: tokenDict))
            return .token(token)
        } else if let error = result["error"] as? [String: Any] {
            return .error(error)
        } else if let error = result["error"] as? String {
            return .error(["error": error])
        } else {
            throw NSError(domain: "UserSignInError", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        }
    }
    
    // createUser sends the network call to POST /users and returns the result
    func createUser(withEmail email: String, password: String, name: String) async throws -> CreateUserResult  {
        // set endpoints and request body
        let endpoint = "http://localhost:3000/v1/users"
        let requestBody = ["name": name, "email": email, "password": password]
        
        // Send post request
        let result = try await Post(to: endpoint, with: requestBody)
        
        // Check the response wrapper
        if let userDict = result["user"] as? [String: Any] {
            let user = try JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: userDict))
            return .user(user)
        } else if let error = result["error"] as? [String: Any] {
            return .error(error)
        } else {
            throw NSError(domain: "UserCreationError", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])
        }
    }
    
    // Name is valid if its not empty
    func isValidName(name: String) -> Bool {
        return name != ""
    }
    
    // email is valid if it matches the emailRX
    func isValidEmail(email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRX)
        return emailPredicate.evaluate(with: email)
    }
    
    // password is valid if it is at least 8 characters
    func isValidPassword(password: String) -> Bool {
        return password.count >= 8
    }
    
    // isValidConfirmPassword is valid if the password and confirm password match
    func isValidConfirmPassword(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
}

enum AuthError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
