//
//  RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: SwitchRecipeViewModel
    @Bindable private var navigator = NavigationManager.nav
    @State private var searchTerm = ""
    @State private var isShowingCreateRecipeView = false
    let curMethod: Method
    
    init(curMethod: Method) {
        self.curMethod = curMethod
        let service = DefaultSwitchRecipeService(baseURL: EnvironmentManager.current.baseURL)
        
        _viewModel = StateObject(wrappedValue: SwitchRecipeViewModel(recipeService: service))
    }
    
    var filteredRecipes: [SwitchRecipe] {
        guard !searchTerm.isEmpty else { return viewModel.recipes }
        return viewModel.recipes.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Recipes")
                    .font(.title)
                    .italic()
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
                    CreateRecipeView(viewModel: viewModel, coffeeViewModel: CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL)))
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
                        .environmentObject(authViewModel)
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
        .addToolbar()
        .task {
            do {
                try await viewModel.fetchSwitchRecipes(withToken: authViewModel.token ?? "", methodId: 2)
            } catch {
                print("Error getting recipes: \(error)")
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    NavigationStack {
        RecipeListView(curMethod: Method(id: 2, name: "Hario Switch"))
            .environmentObject(authViewModel)
    }
}
