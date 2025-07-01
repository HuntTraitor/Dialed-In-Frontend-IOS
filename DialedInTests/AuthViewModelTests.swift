//
//  AuthViewModelTests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/1/25.
//

import Testing
@testable import DialedIn

@MainActor
struct AuthViewModelTests {
    @Test func user_is_successfully_created() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.createUser(email: "test@example.com", password: "password", name: "Test User")
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func user_creation_fails_with_error() async throws {
        let mockAuthService = MockAuthService()
        mockAuthService.isErrorThrown = true
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.createUser(email: "test@example.com", password: "password", name: "Test User")
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test func user_sign_in_successful() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.signIn(email: "test@example.com", password: "password")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isAuthenticated)
        #expect(viewModel.user == User.MOCK_USER)
        #expect(viewModel.token == Token.MOCK_TOKEN.token)
    }
    
    @Test func user_sign_in_fails_with_incorrect_credentials() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.signIn(email: "test@example.com", password: "wrongpassword")
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.user == nil)
        #expect(viewModel.token == nil)
    }
    
    @Test func user_sign_in_fails_with_other_error() async throws {
        let mockAuthService = MockAuthService()
        mockAuthService.isErrorThrown = true
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.signIn(email: "test@example.com", password: "password")
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test func fails_to_verify_session_not_signed_in() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        #expect(await viewModel.verifySession() == false)
    }
    
    @Test func succeeds_to_verify_session_signed_in() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.signIn(email: "test@example.com", password: "password")
        #expect(await viewModel.verifySession() == true)
    }
    
    @Test func fails_to_verify_session_error_signs_the_user_out() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.signIn(email: "test@example.com", password: "password")
        #expect(await viewModel.verifySession() == true)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isAuthenticated)
        #expect(viewModel.user == User.MOCK_USER)
        #expect(viewModel.token == Token.MOCK_TOKEN.token)
        mockAuthService.isErrorThrown = true
        #expect(await viewModel.verifySession() == false)
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.user == nil)
        #expect(viewModel.token == nil)
    }
    
    @Test func signing_out_user_removes_credentials() async throws {
        let mockAuthService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuthService)
        try await viewModel.signIn(email: "test@example.com", password: "password")
        viewModel.signOut()
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.user == nil)
        #expect(viewModel.token == nil)
        #expect(viewModel.errorMessage == nil)
        
        
    }
}

