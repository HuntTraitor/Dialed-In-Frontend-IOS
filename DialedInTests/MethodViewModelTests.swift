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
        let mockService = MockMethodService()
        mockService.isErrorThrown = true
        let viewModel = MethodViewModel(methodService: mockService)
        await viewModel.fetchMethods()
        #expect(viewModel.methods.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }
}
