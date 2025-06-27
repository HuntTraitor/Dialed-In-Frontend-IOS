//
//  RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @StateObject var viewModel = RecipeViewModel()
    @Bindable private var navigator = NavigationManager.nav
    @State private var searchTerm = ""
    @State private var isShowingCreateRecipeView = false
    @State private var refreshData = false
    let curMethod: Method
    
    var filteredRecipes: [SwitchRecipe] {
        guard !searchTerm.isEmpty else { return viewModel.switchRecipes }
        return viewModel.switchRecipes.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            VStack {
                HStack {
                    Text("Recipes")
                        .font(.title)
                        .italic()
                        .underline()
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .padding(.leading, 30)
                    Spacer()
                    Button {
                        isShowingCreateRecipeView = true
                    } label: {
                        Label("Add New Recipe", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                    .padding(.top, 40)
                    .italic()
                    .sheet(isPresented: $isShowingCreateRecipeView) {
                        CreateRecipeView(viewModel: viewModel, coffeeViewModel: CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL)), refreshData: $refreshData)
                    }
                }
                SearchBar(text: $searchTerm, placeholder: "Search Recipes")
                    .padding(.horizontal, 10)
                ScrollView {
                    ForEach(filteredRecipes, id: \.self) { recipe in
                        NavigationLink(
                            destination: RecipeView(
                                recipe: recipe
                            )
                            .environmentObject(keychainManager)
                        ) {
                            RecipeCard(recipe: recipe)
                                .frame(maxWidth: .infinity, maxHeight: 120)
                                .padding()
                                .background(Color(.systemBackground))
                   
                                
                                .cornerRadius(15)
                                .shadow(radius: 2)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .addToolbar()
        .addNavigationSupport()
        .task {
            do {
                try await viewModel.fetchSwitchRecipes(withToken: keychainManager.getToken(), methodId: 2)
            } catch {
                print("Error getting recipes: \(error)")
            }
        }
        .onChange(of: refreshData) {
            Task {
                do {
                    try await viewModel.fetchSwitchRecipes(withToken: keychainManager.getToken(), methodId: 2)
                } catch {
                    print("Error refreshing recipes: \(error)")
                }
            }
        }
    }
}

//struct RecipeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let keychainManager = KeychainManager()
//        RecipeListView(curMethod: Method(id: 1, name: "Pour Over"))
//            .environmentObject(keychainManager)
//    }
//}
