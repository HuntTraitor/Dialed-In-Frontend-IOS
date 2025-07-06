//
//  CoffeeRow.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/21/25.
//

import SwiftUI

struct CoffeeRow: View {
    var coffee: Coffee
    @ObservedObject var viewModel: CoffeeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationLink(
            destination: CoffeeCard(coffee: coffee, viewModel: viewModel)
                .environmentObject(authViewModel)
        ) {
            CoffeeCardSmall(coffee: coffee)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    let viewModel = CoffeeViewModel(coffeeService: MockCoffeeService())
    CoffeeRow(coffee: Coffee.MOCK_COFFEE, viewModel: viewModel)
        .environmentObject(authViewModel)
}
