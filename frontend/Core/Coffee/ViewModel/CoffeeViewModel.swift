//
//  CoffeeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/25/25.
//

import Foundation

@MainActor
class CoffeeViewModel: ObservableObject {
    @Published var coffees: [Coffee] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let coffeeService: CoffeeService
    
    init(coffeeService: CoffeeService) {
        self.coffeeService = coffeeService
    }
    
    func fetchCoffees(withToken token: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await coffeeService.fetchCoffees(withToken: token)
            switch result {
            case .coffees(let coffees):
                self.coffees = coffees
            case .error(let errorDict):
                errorMessage = errorDict["message"] as? String
            }
        } catch {
            errorMessage = "Failed to fetch coffees: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func postCoffee(input: CoffeeInput, token: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await coffeeService.postCoffee(input: input, token: token)
            switch result {
            case .coffee:
                await fetchCoffees(withToken: token)
            case .error(let errorDict):
                errorMessage = errorDict["message"] as? String
            }
        } catch {
            errorMessage = "Failed to post coffee: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await coffeeService.deleteCoffee(coffeeId: coffeeId, token: token)
            switch result {
            case .deleted:
                await fetchCoffees(withToken: token)
            case .error(let errorDict):
                errorMessage = errorDict["message"] as? String
            }
        } catch {
            errorMessage = "Failed to delete coffee: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async throws -> Coffee {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await coffeeService.updateCoffee(input: input, token: token)
            switch result {
            case .coffee(let coffee):
                await fetchCoffees(withToken: token)
                isLoading = false
                return coffee
            case .error(let errorDict):
                let message = errorDict["message"] as? String ?? "Unknown error"
                errorMessage = message
                isLoading = false
                throw APIError.requestFailed(description: message)
            }
        } catch {
            errorMessage = "Failed to update coffee: \(error.localizedDescription)"
            isLoading = false
            throw error
        }
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
