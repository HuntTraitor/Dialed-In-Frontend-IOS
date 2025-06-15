//
//  CoffeeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/25/25.
//

import Foundation

class CoffeeViewModel: ObservableObject {
    @Published var coffees: [Coffee] = []
    
    func fetchCoffees(withToken token: String) async {
        do {
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
            
            await MainActor.run {
                self.coffees = coffees
            }
        } catch {
            print("Error fetching coffees: \(error)")
        }
    }
    
    func postCoffee(input: CoffeeInput, token: String) async throws {
        let url = URL(string: "http://localhost:3000/v1/coffees")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let postData = input.toMultiPartData(boundary: boundary)
        request.httpBody = postData

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw CustomError.methodError(message: "Failed to upload coffee")
        }
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async throws {
        let endpoint = "http://localhost:3000/v1/coffees/\(coffeeId)"
        let headers = ["Authorization": "Bearer \(token)"]
        
        let result = try await Delete(to: endpoint, with: headers)
        
        if result["message"] as? String != "coffee successfully deleted" {
            throw CustomError.methodError(message: "Failed to delete coffee, \(result)")
        }
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> Coffee{
        let url = URL(string: "http://localhost:3000/v1/coffees/\(String(describing: input.id!))")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let patchData = input.toMultiPartData(boundary: boundary)
        request.httpBody = patchData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomError.methodError(message: "Failed to upload coffee")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        
        
        guard let coffeeDict = json["coffee"] as? [String: Any] else {
            throw CustomError.methodError(message: "Error when parsing coffees")
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: coffeeDict, options: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let coffee = try decoder.decode(Coffee.self, from: jsonData)
        return coffee
    }
    
    func isValidName(name: String) -> Bool {
        return name != "" || name.count > 500
    }
    
    func isValidDescription(description: String) -> Bool {
        return description != "" || description.count > 1000
    }
    
    func isValidProcess(process: String) -> Bool {
        return process != "" || process.count > 200
    }
    
    func isValidRegion(region: String) -> Bool {
        return region != "" || region.count > 100
    }
}
