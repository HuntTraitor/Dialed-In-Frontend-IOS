//
//  MockMethodService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockMethodService: MethodService {
    var isErrorThrown = false
    func fetchMethods() async throws -> [Method] {
        if isErrorThrown {
            throw APIError.custom(message: "Could not fetch methods, please try again")
        }
        return Method.MOCK_METHODS
    }
}
