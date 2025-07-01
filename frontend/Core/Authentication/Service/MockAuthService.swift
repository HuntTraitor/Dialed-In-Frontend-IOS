//
//  MockAuthService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockAuthService: AuthService {
    var isErrorThrown = false
    func signIn(withEmail email: String, password: String) async throws -> SignInResult {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if email != User.MOCK_USER.email {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else if password != "password" {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return .token(Token.MOCK_TOKEN)
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws -> CreateUserResult {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return .user(User.MOCK_USER)
        }
    }
        
    func verifyUser(withToken token: String) async throws -> User {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return User.MOCK_USER
        }
    }
}

