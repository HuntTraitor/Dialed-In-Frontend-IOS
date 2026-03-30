//
//  DefaultCoffeeService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class DefaultCoffeeService: BaseApiService, CoffeeService {
    
    func fetchCoffees(withToken token: String) async throws -> [Coffee] {
        let request = authorizedRequest(path: "coffees", method: "GET", token: token)
        let data = try await perform(request)
        return try decode(MultiCoffeeResponse.self, from: data).coffees
    }
    
    func postCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        let request = multipartRequest(path: "coffees", method: "POST", token: token, input: input)
        let data = try await perform(request)
        return try decode(SingleCoffeeResponse.self, from: data).coffee
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        guard let id = input.id else {
            throw APIError.requestFailed(description: "Missing coffee ID for update")
        }
        let request = multipartRequest(path: "coffees/\(id)", method: "PATCH", token: token, input: input)
        let data = try await perform(request)
        return try decode(SingleCoffeeResponse.self, from: data).coffee
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async throws -> Bool {
        let request = authorizedRequest(path: "coffees/\(coffeeId)", method: "DELETE", token: token)
        _ = try await perform(request)
        return true
    }
    
    //MARK: - Multipart Helper
    
    private func multipartRequest(path: String, method: String, token: String, input: CoffeeInput) -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("Barer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = input.toMultiPartData(boundary: boundary)
        return request
    }
}
