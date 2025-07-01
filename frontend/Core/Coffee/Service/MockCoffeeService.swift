//
//  MockCoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockCoffeeService: CoffeeService {
    var isErrorThrown = false
    func fetchCoffees(withToken token: String) async throws -> FetchCoffeesResult {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return .coffees(Coffee.MOCK_COFFEES)
        }
    }
    
    func postCoffee(input: CoffeeInput, token: String) async throws -> PostCoffeeResult {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return .coffee(Coffee.MOCK_COFFEE)
        }
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async throws -> DeleteCoffeeResult {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if coffeeId != Coffee.MOCK_COFFEE.id {
            throw APIError.invalidStatusCode(statusCode: 404)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return .deleted(true)
        }
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> UpdateCoffeeResult {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if token != Token.MOCK_TOKEN.token {
            throw APIError.invalidStatusCode(statusCode: 401)
        } else {
            return .coffee(Coffee.MOCK_COFFEE)
        }
    }
}

