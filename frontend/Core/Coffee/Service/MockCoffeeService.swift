//
//  MockCoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockCoffeeService: CoffeeService {
    var isErrorThrown = false
    var noCoffeesFound = false
    func fetchCoffees(withToken token: String) async throws -> [Coffee] {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if noCoffeesFound {
            return []
        } else {
            return Coffee.MOCK_COFFEES
        }
    }
    
    func postCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return Coffee.MOCK_COFFEE
        }
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async throws -> Bool {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if coffeeId != Coffee.MOCK_COFFEE.id {
            throw APIError.invalidStatusCode(statusCode: 404)
        } else {
            return true
        }
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return Coffee.MOCK_COFFEE
        }
    }
}

