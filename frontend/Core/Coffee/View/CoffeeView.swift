//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CoffeeViewModel
    @Bindable private var navigator = NavigationManager.nav
    @State private var pressedItemId: Int?
    @State private var searchTerm = ""
    @State private var isShowingCreateCoffeeView = false
    @State private var hasAppeared: Bool = false
    @State private var isMinimized: Bool = false
    
    private let testingID = UIIdentifiers.CoffeeScreen.self
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return viewModel.coffees }
        return viewModel.coffees.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Coffees")
                            .font(.title)
                            .italic()
                            .padding(.top, 40)
                            .padding(.bottom, 10)
                            .padding(.leading, 30)
                            .accessibilityIdentifier(testingID.coffeesTitle)
                        
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
                            CreateCoffeeView()
                        }
                        .padding(.top, 40)
                    }
                    
                    if viewModel.errorMessage != nil {
                        FetchErrorMessageScreen(errorMessage: viewModel.errorMessage)
                            .scaleEffect(0.8)
                            .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.coffees.isEmpty {
                        NoResultsFound(itemName: "coffee", systemImage: "cup.and.heat.waves")
                            .scaleEffect(0.8)
                            .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        VStack {
                            HStack {
                                SearchBar(text: $searchTerm, placeholder: "Search Coffees")
                                    .padding(.horizontal, 10)
                                Button(action: {
                                    isMinimized.toggle()
                                }) {
                                    Image(systemName: isMinimized ? "chevron.up" : "chevron.down")
                                }
                            }
                            .padding(.bottom, 5)
                            
                            if filteredCoffees.isEmpty && !searchTerm.isEmpty {
                                NoSearchResultsFound(itemName: "coffee")
                                    .scaleEffect(0.8)
                                    .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView {
                                    ForEach(filteredCoffees, id: \.id) { coffee in
                                        VStack {
                                            CoffeeRow(coffee: coffee, isMinimized: $isMinimized)
                                        }
                                        .padding(.vertical, 10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.01), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal)
                .addNavigationSupport()
                .task {
                    if !hasAppeared {
                        await viewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                        hasAppeared = true
                    }
                }
            }
            if viewModel.isLoading {
                LoadingCircle()
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        CoffeeView()
    }
}
