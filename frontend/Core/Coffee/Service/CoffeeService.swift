//
//  CoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

protocol CoffeeService {
    func fetchCoffees(withToken token: String) async throws -> FetchCoffeesResult
    func postCoffee(input: CoffeeInput, token: String) async throws -> PostCoffeeResult
    func deleteCoffee(coffeeId: Int, token: String) async throws -> DeleteCoffeeResult
    func updateCoffee(input: CoffeeInput, token: String) async throws -> UpdateCoffeeResult
}

