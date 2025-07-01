//
//  MethodViewModelTests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

import Testing
@testable import DialedIn

@MainActor
struct MethodViewModelTests {
    @Test func fetch_methods_successful() async throws {
        let mockService = MockMethodService()
        let viewModel = MethodViewModel(methodService: mockService)
        await viewModel.fetchMethods()
        #expect(viewModel.methods.count == 2)
    }
    
    @Test func testFetchMethods_handlesAllErrors() async throws {
        let allErrors: [MockErrorType] = [.requestFailed, .invalidStatusCode, .jsonParsingFailure, .unknownError]

        let expectedMessages: [MockErrorType: String] = [
            .requestFailed: "Request failed",
            .invalidStatusCode: "Invalid status code",
            .jsonParsingFailure: "Failed to parse JSON",
            .unknownError: "Unknown error"
        ]

        for error in allErrors {
            await testErrorHandling(
                errorType: error,
                createService: { MockMethodService() },
                createViewModel: { MethodViewModel(methodService: $0) },
                performFetch: { await $0.fetchMethods() },
                verify: { viewModel in
                    guard let errorMessage = viewModel.errorMessage else {
                        #expect(Bool(false), "Expected an error message but got nil")
                        return
                    }
                    guard let expected = expectedMessages[error] else {
                        #expect(Bool(false), "Expected message for error type \(error)")
                        return
                    }
                    #expect(errorMessage.contains(expected), "Expected error message to contain: \(expected)")
                }
            )
        }
    }
}
