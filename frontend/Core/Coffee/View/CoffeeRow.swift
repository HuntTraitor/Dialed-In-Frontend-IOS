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
    @Binding var pressedItemId: Int?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationLink(
            destination: CoffeeCard(coffee: coffee, coffeeViewModel: viewModel)
                .environmentObject(authViewModel)
        ) {
            CoffeeCardSmall(coffee: coffee)
                .opacity(pressedItemId == coffee.id ? 0.8 : 1)
                .contentShape(Rectangle())
                .pressEvent(onPress: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        pressedItemId = coffee.id
                    }
                }, onRelease: {
                    withAnimation {
                        pressedItemId = nil
                    }
                })
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded ({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressEvent(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) ->
    some View {
        modifier(ButtonPress(onPress: {onPress()}, onRelease: {onRelease()}))
    }
}

//#Preview {
//    CoffeeRow(coffee: Coffee.MOCK_COFFEE, viewModel: CoffeeViewModel(), pressedItemId: .constant(1))
//        .environmentObject(KeychainManager())
//}
