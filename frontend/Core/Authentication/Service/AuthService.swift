//
//  AuthService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

protocol AuthService {
    func signIn(withEmail email: String, password: String) async throws -> Token
    func createUser(withEmail email: String, password: String, name: String) async throws -> User
    func verifyUser(withToken token: String) async throws -> User
    func sendPasswordResetEmail(toEmail email: String) async throws -> EmailSentResponse
    func resetPassword(password: String, code: String) async throws -> PasswordResetResponse
}

