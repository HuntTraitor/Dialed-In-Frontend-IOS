//
//  CoffeeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/25/25.
//

import Foundation

class CoffeeViewModel: ObservableObject {
    func getCoffees(withToken token: String) async throws -> [Coffee] {
        let endpoint = "http://localhost:3000/v1/coffees"
        let headers = ["Authorization": "Bearer \(token)"]
        
        let result = try await Get(to: endpoint, with: headers)
        
        guard let coffeeDicts = result["coffees"] as? [[String: Any]] else {
            throw CustomError.methodError(message: "Error when parsing coffees")
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: coffeeDicts, options: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let coffees = try decoder.decode([Coffee].self, from: jsonData)
        return coffees
    }

}
