//
//  MockMethodService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockMethodService: MethodService, MockServiceWithError {
    var errorType: MockErrorType = .none
    func fetchMethods() async throws -> [Method] {
        switch errorType {
        case .requestFailed:
            throw APIError.requestFailed(description: "No Valid HTTP Response")
        case .invalidStatusCode:
            throw APIError.invalidStatusCode(statusCode: 500)
        case .jsonParsingFailure:
            throw APIError.jsonParsingFailure(error: DummyError.someError)
        case .unknownError:
            throw APIError.unknownError(error: DummyError.someError)
        case .none:
            return Method.MOCK_METHODS
        }
    }
}
