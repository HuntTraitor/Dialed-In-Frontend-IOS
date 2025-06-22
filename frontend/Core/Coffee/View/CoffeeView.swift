//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @StateObject var viewModel = CoffeeViewModel()
    @Bindable private var navigator = NavigationManager.nav
    @State private var pressedItemId: Int?
    @State private var searchTerm = ""
    @State private var isShowingCreateCoffeeView = false
    @State public var refreshData: Bool = false
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return viewModel.coffees }
        return viewModel.coffees.filter {$0.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            VStack {
                HStack {
                    Text("Coffees")
                        .font(.title)
                        .italic()
                        .underline()
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Button {
                        isShowingCreateCoffeeView = true
                    } label: {
                        Label("Add New Coffee", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                    .sheet(isPresented: $isShowingCreateCoffeeView) {
                        CreateCoffeeView(viewModel: viewModel, refreshData: $refreshData)
                    }
                    .padding(.top, 40)
                    .italic()

                }
                
                SearchBar(text: $searchTerm, placeholder: "Search Coffees")

                ScrollView {
                    ForEach(filteredCoffees, id: \.id) { coffee in
                        CoffeeRow(coffee: coffee, viewModel: viewModel, pressedItemId: $pressedItemId)
                }
                    .padding()
                }
            }
            .addToolbar()
            .addNavigationSupport()
            .task {
                await viewModel.fetchCoffees(withToken: keychainManager.getToken())
            }
            .onChange(of: refreshData) { oldValue, newValue in
                print("🔄 onChange triggered: oldValue = \(oldValue), newValue = \(newValue)")
                if newValue {
                    Task {
                        await viewModel.fetchCoffees(withToken: keychainManager.getToken())
                        refreshData = false
                    }
                }
            }
        }
    }
}

#Preview {
    let keychainManager = KeychainManager()
    return CoffeeView()
        .environmentObject(keychainManager)
}
