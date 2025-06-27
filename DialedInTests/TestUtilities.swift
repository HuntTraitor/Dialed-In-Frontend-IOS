//
//  TestUtilities.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

import Foundation
import Testing
@testable import DialedIn

func testErrorHandling<VM: AnyObject>(
    for errorType: MockErrorType,
    createViewModel: (MockMethodService) -> VM,
    performFetch: @MainActor (VM) async -> Void,
    verify: @MainActor (VM) -> Void
) async {
    let mockService = MockMethodService()
    mockService.errorType = errorType
    let viewModel = createViewModel(mockService)

    await performFetch(viewModel)
    await MainActor.run {
        verify(viewModel)
    }
}


