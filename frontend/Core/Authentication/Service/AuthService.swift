//
//  AuthService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

protocol AuthService {
    func signIn(withEmail email: String, password: String) async throws -> SignInResult
    func createUser(withEmail email: String, password: String, name: String) async throws -> CreateUserResult
    func verifyUser(withToken token: String) async throws -> User
}

