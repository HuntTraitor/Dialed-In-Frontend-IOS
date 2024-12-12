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
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Signs the user in")
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws -> User {
        let endpoint = "http://localhost:3000/v1/users"
        let requestBody = ["name": name, "email": email, "password": password]
        
        // Send post request
        let result = try await Post(to: endpoint, with: requestBody)
        
        // Check if the "user" key exists and contains a dictionary of type [String: Any]
        if let user = result["user"] as? [String: Any] {
            let jsonData = try JSONSerialization.data(withJSONObject: user, options: [])
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                // Decode the user data into a User object
                let user = try decoder.decode(User.self, from: jsonData)
                return user
            } catch {
                // Handle error during decoding and throw with a custom message
                print("Error decoding user: \(error)")
                throw NSError(domain: "UserCreationError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Error decoding user: \(error.localizedDescription)"])
            }
        } else if let error = result["error"] as? [String: Any] {
            // If there is an error in the response, print each validation error
            for (field, message) in error {
                print("Field \(field) error: \(message)")
            }
            // Throw an error if validation fails
            throw NSError(domain: "UserCreationError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Error in user creation response: \(error)"])
        } else {
            // If neither 'user' nor 'error' are present, something went wrong
            print("Unexpected response format: \(result)")
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
