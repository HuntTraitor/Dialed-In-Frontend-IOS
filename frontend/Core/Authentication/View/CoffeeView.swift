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
        Coffee(id: 2, name: "Milky Cake", region: "Columbia", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 3, name: "Milky Cake", region: "Columbia", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 4, name: "Milky Cake", region: "Columbia", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"),
        Coffee(id: 5, name: "Milky Cake", region: "Columbia", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png")
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            VStack{
                Text("Coffee List")
            }
                .padding(20)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(coffeeItems, id: \.id) { coffee in
                        CoffeeCard(name: coffee.name, region: coffee.region, description: coffee.description, imgURL: coffee.imgURL)

                    }
                }
                .padding(.horizontal, 30)

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
