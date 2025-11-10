//
//  MockAuthService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockAuthService: AuthService {
    var isErrorThrown = false
    func signIn(withEmail email: String, password: String) async throws -> Token {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if email != User.MOCK_USER.email {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else if password != "password" {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return Token.MOCK_TOKEN
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws -> User {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return User.MOCK_USER
        }
    }
    
    func verifyUser(withToken token: String) async throws -> User {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return User.MOCK_USER
        }
    }
    
    func sendPasswordResetEmail(toEmail email: String) async throws -> EmailSentResponse {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return Token.MOCK_EMAIL_SENT_RESPONSE
        }
    }
    
    func resetPassword(password: String, code: String) async throws -> PasswordResetResponse {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return Token.MOCK_PASSWORD_RESET_RESPONSE
        }
    }
}

