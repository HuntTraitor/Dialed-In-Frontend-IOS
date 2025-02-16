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
    
    let coffeeItems = [
        Coffee.MOCK_COFFEE,
        Coffee(id: 2, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 3, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 4, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 5, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
    ]
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            VStack {
                Text("Coffees")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 25)
            .padding(.leading, 50)
            .italic()
            ScrollView {
                ForEach(coffeeItems, id: \.id) { coffee in
                    CoffeeCardSmall(title: coffee.name, imgURL: coffee.imgURL)
                }
            }
            .addToolbar()
            .addNavigationSupport()
        }
    }
}

#Preview {
    let keychainManager = KeychainManager()
    return CoffeeView()
        .environmentObject(keychainManager)
}
