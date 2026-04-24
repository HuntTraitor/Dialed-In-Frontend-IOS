//
//  CoffeeViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/25/25.
//

import Foundation

@MainActor
class CoffeeViewModel: ObservableObject {
    @Published var coffeeMetadata: CoffeeMetadata?
    @Published var coffees: [Coffee] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published private(set) var coffeeQueryItems: [URLQueryItem] = []
    @Published var query = CoffeeQuery(page: 1) {
        didSet {
            coffeeQueryItems = query.queryItems
        }
    }
    
    private let coffeeService: CoffeeService
    
    init(coffeeService: CoffeeService) {
        self.coffeeService = coffeeService
    }
    
    func fetchCoffees(withToken token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            query.page = 1
            coffeeQueryItems = query.queryItems
            let response = try await coffeeService.fetchCoffees(withToken: token, query: coffeeQueryItems)
            self.coffees = response.coffees
            self.coffeeMetadata = response.metadata
        } catch {
            errorMessage = "Failed to fetch coffees: \(error.localizedDescription)"
        }
    }
    
    func shouldFetchMore(after coffee: Coffee) -> Bool {
        guard !isLoadingMore, !isLoading else { return false }
        guard let currentPage = coffeeMetadata?.currentPage,
              let lastPage = coffeeMetadata?.lastPage,
              currentPage < lastPage else { return false }
        guard let coffeeIndex = coffees.firstIndex(where: { $0.id == coffee.id }) else { return false }
        guard !coffees.isEmpty else { return false }

        let thresholdIndex = max(coffees.count - 3, 0)
        let lastIndex = coffees.index(before: coffees.endIndex)
        return coffeeIndex == thresholdIndex || coffeeIndex == lastIndex
    }

    func fetchMore(withToken token: String) async {
        guard !isLoadingMore, !isLoading else { return }
        guard let currentPage = coffeeMetadata?.currentPage,
              let lastPage = coffeeMetadata?.lastPage,
              currentPage < lastPage else { return }

        query.page += 1
        
        isLoadingMore = true
        errorMessage = nil
        defer { isLoadingMore = false }
        
        do {
            coffeeQueryItems = query.queryItems
            let response = try await coffeeService.fetchCoffees(withToken: token, query: coffeeQueryItems)
            self.coffees.append(contentsOf: response.coffees)
            self.coffeeMetadata = response.metadata
        } catch {
            errorMessage = "Failed to fetch more coffees: \(error.localizedDescription)"
        }

    }
    
    func postCoffee(input: CoffeeInput, token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await coffeeService.postCoffee(input: input, token: token)
            await fetchCoffees(withToken: token)
        } catch {
            errorMessage = "Failed to post coffee: \(error.localizedDescription)"
        }
    }
    
    func deleteCoffee(coffeeId: Int, token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let deleted = try await coffeeService.deleteCoffee(coffeeId: coffeeId, token: token)
            if deleted {
                await fetchCoffees(withToken: token)
            }
        } catch {
            errorMessage = "Failed to delete coffee: \(error.localizedDescription)"
        }
    }
    
    func updateCoffee(input: CoffeeInput, token: String) async -> Coffee? {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let coffee = try await coffeeService.updateCoffee(input: input, token: token)
            await fetchCoffees(withToken: token)
            return coffee
        } catch {
            errorMessage = "Failed to update coffee: \(error.localizedDescription)"
            return nil
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
