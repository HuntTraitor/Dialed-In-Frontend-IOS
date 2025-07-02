//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: CoffeeViewModel
    @Bindable private var navigator = NavigationManager.nav
    @State private var pressedItemId: Int?
    @State private var searchTerm = ""
    @State private var isShowingCreateCoffeeView = false
    @State public var refreshData: Bool = false
    
    init() {
        let service = DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL)
        _viewModel = StateObject(wrappedValue: CoffeeViewModel(coffeeService: service))
    }
    
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
                        CreateCoffeeView(viewModel: viewModel)
                    }
                    .padding(.top, 40)
                    .italic()
                }
                
                SearchBar(text: $searchTerm, placeholder: "Search Coffees")
                    .padding(.horizontal, 10)

                ScrollView {
                    ForEach(filteredCoffees, id: \.id) { coffee in
                        CoffeeRow(coffee: coffee, viewModel: viewModel)
                }
                    .padding()
                }
            }
            .addToolbar()
            .addNavigationSupport()
            .task {
                await viewModel.fetchCoffees(withToken: authViewModel.token ?? "")
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    CoffeeView()
        .environmentObject(authViewModel)
}
