//
//  CoffeeRow.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/21/25.
//

import SwiftUI

struct CoffeeRow: View {
    var coffee: Coffee
    @Binding var isMinimized: Bool
    @EnvironmentObject var viewModel: CoffeeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationLink(
            destination: CoffeeCard(coffee: coffee)
                .environmentObject(authViewModel)
        ) {
            if isMinimized {
                CoffeeCardExtraSmall(coffee: coffee)
            } else {
                CoffeeCardSmall(coffee: coffee)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var isMinimized = true

    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    let viewModel = CoffeeViewModel(coffeeService: MockCoffeeService())

    return CoffeeRow(coffee: Coffee.MOCK_COFFEE, isMinimized: $isMinimized)
        .environmentObject(authViewModel)
}
