//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @Bindable private var navigator = NavigationManager.nav
    @State private var pressedItemId: Int?

    let coffeeItems = [
        Coffee.MOCK_COFFEE,
        Coffee(id: 2, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://www.lankerpack.com/wp-content/uploads/2023/04/matte-coffee-bag-mockup-template.png"),
        Coffee(id: 3, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 4, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 5, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
    ]
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            VStack {
                Text("Coffees")
            }
            .padding(.top, 40)
            .padding(.bottom, 15)
            .italic()
            .underline()
            ScrollView {
                ForEach(coffeeItems, id: \.id) { coffee in
                    NavigationLink(destination: CoffeeCard(coffee: coffee)) {
                        CoffeeCardSmall(coffee: coffee)
                            .opacity(pressedItemId == coffee.id ? 0.8 : 1)
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
            .padding()
            .addToolbar()
            .addNavigationSupport()
        }
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

#Preview {
    let keychainManager = KeychainManager()
    return CoffeeView()
        .environmentObject(keychainManager)
}
