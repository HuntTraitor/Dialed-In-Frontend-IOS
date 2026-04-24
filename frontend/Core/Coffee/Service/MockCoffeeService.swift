//
//  MockCoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class MockCoffeeService: CoffeeService {
    var isErrorThrown = false
    var noCoffeesFound = false
    private(set) var lastQuery: [URLQueryItem] = []

    private func validateToken(_ token: String) throws {
        if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        }
    }

    func fetchCoffees(withToken token: String, query: [URLQueryItem]) async throws -> MultiCoffeeResponse {
        lastQuery = query

        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if noCoffeesFound {
            try validateToken(token)
            return MultiCoffeeResponse(
                coffees: [],
                metadata: CoffeeMetadata()
            )
        } else {
            try validateToken(token)
            return Coffee.MOCK_COFFEES
        }
    }
    
    func postCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            try validateToken(token)
            return Coffee.MOCK_COFFEE
        }
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async throws -> Bool {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if coffeeId != Coffee.MOCK_COFFEE.id {
            try validateToken(token)
            throw APIError.invalidStatusCode(statusCode: 404)
        } else {
            try validateToken(token)
            return true
        }
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            try validateToken(token)
            return Coffee.MOCK_COFFEE
        }
    }
}
