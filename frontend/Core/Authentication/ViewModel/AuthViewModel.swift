//
//  AuthViewModel.swift
//  frontend
//
//  Created by Hunter Tratar on 12/11/24.
//

import Foundation
import SimpleKeychain

@MainActor
class AuthViewModel: ObservableObject {
    private let authService: AuthService
    private let keychain = SimpleKeychain()
    
    @Published private(set) var session: AuthSessionState?
    @Published var hasVerifiedSession = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init(authService: AuthService) {
        self.authService = authService

        if let data = try? keychain.data(forKey: "auth_session"),
           let savedSession = try? JSONDecoder().decode(AuthSessionState.self, from: data) {
            self.session = savedSession
            verifySessionAfterLaunch()
        } else {
            hasVerifiedSession = true
        }
    }
    
    var isAuthenticated: Bool {
        hasVerifiedSession && session != nil
    }
    
    var user: User? {
        session?.user
    }
    
    var token: String? {
        session?.token.token
    }
    
    func verifySessionAfterLaunch() {
        Task {
            _ = await verifySession()
            hasVerifiedSession = true
        }
    }
    
    // SignIn signs in the user and sets the session information
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await authService.signIn(withEmail: email, password: password)
            guard case .token(let token) = result else {
                
                // if there is an error, throw the error in the json
                if case .error(let errorDict) = result {
                    throw AuthSessionError.unknown(errorDict["error"] as? String ?? "Unknown error")
                } else {
                    throw AuthSessionError.unknown("Unknown auth error")
                }
            }
            
            let user = try await authService.verifyUser(withToken: token.token)
            let session = AuthSessionState(token: token, user: user)
            self.session = session
            if let data = try? JSONEncoder().encode(session) {
                try? keychain.set(data, forKey: "auth_session")
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // signOut removes the user session from the keychain
    func signOut() {
        isLoading = true
        session = nil
        try? keychain.deleteItem(forKey: "auth_session")
        isLoading = false
    }
    
    // verifySession returns true of false if the users session is still valid
    func verifySession() async -> Bool {
        // if there is no token return false
        guard let token = session?.token.token else { return false }
        
        // if the user is verified with the token return true
        do {
            let user = try await authService.verifyUser(withToken: token)
            let newSession = AuthSessionState(token: session!.token, user: user)
            session = newSession
            if let data = try? JSONEncoder().encode(newSession) {
                try? keychain.set(data, forKey: "auth_session")
            }
            return true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        // otherwise signout and return false
        signOut()
        return false
    }
    
    func createUser(email: String, password: String, name: String) async throws {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await authService.createUser(withEmail: email, password: password, name: name)
            switch result {
            case .user(let user):
                print(user)
            case .error(let errorDict):
                errorMessage = errorDict["message"] as? String ?? "An Unexpected Error has Occurred"
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
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
