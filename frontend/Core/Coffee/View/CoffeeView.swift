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
    @State private var hasAppeared: Bool = false
    
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
                
                if viewModel.errorMessage != nil {
                    FetchErrorMessageScreen(errorMessage: viewModel.errorMessage)
                        .scaleEffect(0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 10)
                } else if viewModel.coffees.isEmpty {
                    NoResultsFound(itemName: "coffee", systemImage: "cup.and.heat.waves")
                        .scaleEffect(0.8)
                        .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        SearchBar(text: $searchTerm, placeholder: "Search Coffees")
                            .padding(.horizontal, 10)
                        
                        if filteredCoffees.isEmpty && !searchTerm.isEmpty {
                            NoSearchResultsFound(itemName: "coffee")
                                .scaleEffect(0.8)
                                .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                ForEach(filteredCoffees, id: \.id) { coffee in
                                    CoffeeRow(coffee: coffee, viewModel: viewModel)
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .addToolbar()
            .addNavigationSupport()
            .task {
                if !hasAppeared {
                    await viewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                    hasAppeared = true
                }
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    CoffeeView()
        .environmentObject(authViewModel)
}
