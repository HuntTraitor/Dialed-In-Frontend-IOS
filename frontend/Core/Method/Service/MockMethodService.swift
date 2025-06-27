//
//  MockMethodService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

final class MockMethodService: MethodService {
    var shouldThrow = false
    
    func fetchMethods() async throws -> [Method] {
        if shouldThrow {
            throw APIError.invalidData
        }
        return []
    }
}

// EXAMPLE TEST
//func testFetchSuccess() async {
//    let viewModel = CoffeeViewModel(coffeeService: MockCoffeeService())
//    await viewModel.loadCoffees()
//    XCTAssertEqual(viewModel.coffees.count, 2)
//}
