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
    
    @Test func fetchMethods_handlesAllErrors() async throws {
        for error in [MockErrorType.requestFailed, .invalidStatusCode, .jsonParsingFailure, .unknownError] {
            await testErrorHandling(
                for: error,
                createViewModel: { MethodViewModel(methodService: $0) },
                performFetch: { await $0.fetchMethods() },
                verify: { vm in
                    #expect(vm.errorMessage != nil, "Expected errorMessage for \(error)")
                }
            )
        }
    }
}
