//
//  CoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

protocol CoffeeService {
    func fetchCoffees(withToken token: String, query: [URLQueryItem]) async throws -> MultiCoffeeResponse
    func postCoffee(input: CoffeeInput, token: String) async throws -> Coffee
    func deleteCoffee(coffeeId: Int, token: String) async throws -> Bool
    func updateCoffee(input: CoffeeInput, token: String) async throws -> Coffee
}

