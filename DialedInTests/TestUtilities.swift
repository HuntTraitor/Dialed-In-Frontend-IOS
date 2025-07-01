//
//  TestUtilities.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

import Foundation
import Testing
@testable import DialedIn

func testErrorHandling<VM: AnyObject, Service: MockServiceWithError>(
    errorType: MockErrorType,
    createService: () -> Service,
    createViewModel: (Service) -> VM,
    performFetch: @MainActor (VM) async -> Void,
    verify: @MainActor (VM) -> Void
) async {
    var service = createService()
    service.errorType = errorType
    let viewModel = createViewModel(service)
    await performFetch(viewModel)
    await MainActor.run {
        verify(viewModel)
    }
}



