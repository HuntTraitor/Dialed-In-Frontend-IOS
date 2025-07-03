//
//  CoffeeViewModelTests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/1/25.
//

import Testing
@testable import DialedIn

@MainActor
struct CoffeeViewModelTests {
    @Test func fetching_coffee_succesfully_updates_coffees() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.fetchCoffees(withToken: Token.MOCK_TOKEN.token)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.coffees == Coffee.MOCK_COFFEES)
    }
    
    @Test func fetching_coffee_with_bad_token_returns_401() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.fetchCoffees(withToken: "badtoken")
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func fetching_coffee_with_unknown_error() async throws {
        let mockCoffeeService = MockCoffeeService()
        mockCoffeeService.isErrorThrown = true
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.fetchCoffees(withToken: Token.MOCK_TOKEN.token)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func posting_coffee_is_successful() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.postCoffee(input: Coffee.MOCK_COFFEE_INPUT, token: Token.MOCK_TOKEN.token)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.coffees == Coffee.MOCK_COFFEES)
    }
    
    @Test func posting_coffee_with_bad_token_returns_401() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.postCoffee(input: Coffee.MOCK_COFFEE_INPUT, token: "badtoken")
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func posting_coffee_with_unknown_error() async throws {
        let mockCoffeeService = MockCoffeeService()
        mockCoffeeService.isErrorThrown = true
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.postCoffee(input: Coffee.MOCK_COFFEE_INPUT, token: Token.MOCK_TOKEN.token)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func deleting_coffee_is_successful() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.deleteCoffee(coffeeId: Coffee.MOCK_COFFEE.id, token: Token.MOCK_TOKEN.token)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.coffees == Coffee.MOCK_COFFEES)
    }
    
    @Test func deleting_coffee_with_unknown_token_fails() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.deleteCoffee(coffeeId: Coffee.MOCK_COFFEE.id, token: "badtoken")
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func deleting_coffee_with_unkown_coffeeId_fails() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.deleteCoffee(coffeeId: 999, token: Token.MOCK_TOKEN.token)
        #expect(((viewModel.errorMessage?.contains("404")) != nil))
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func deleting_coffee_with_unkown_error_fails() async throws {
        let mockCoffeeService = MockCoffeeService()
        mockCoffeeService.isErrorThrown = true
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        await viewModel.deleteCoffee(coffeeId: Coffee.MOCK_COFFEE.id, token: Token.MOCK_TOKEN.token)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.coffees.isEmpty)
    }
    
    @Test func updating_coffee_is_successful() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        let coffee = await viewModel.updateCoffee(input: Coffee.MOCK_COFFEE_INPUT, token: Token.MOCK_TOKEN.token)
        #expect(coffee == Coffee.MOCK_COFFEE)
        #expect(viewModel.coffees == Coffee.MOCK_COFFEES)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func updating_coffee_with_bad_token_fails() async throws {
        let mockCoffeeService = MockCoffeeService()
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        let coffee = await viewModel.updateCoffee(input: Coffee.MOCK_COFFEE_INPUT, token: "badtoken")
        #expect(coffee == nil)
        #expect(viewModel.coffees.isEmpty)
        #expect(((viewModel.errorMessage?.contains("401")) != nil))
    }
    
    @Test func updating_coffee_with_unknown_error_fails() async throws {
        let mockCoffeeService = MockCoffeeService()
        mockCoffeeService.isErrorThrown = true
        let viewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
        let coffee = await viewModel.updateCoffee(input: Coffee.MOCK_COFFEE_INPUT, token: Token.MOCK_TOKEN.token)
        #expect(coffee == nil)
        #expect(viewModel.coffees.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }
}
