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
        
        // Perform the POST request
        let result = try await Post(to: endpoint, with: requestBody)
        
        print("Result: \(result)")
        
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
}

enum AuthError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
