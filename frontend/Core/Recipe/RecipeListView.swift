//
//  RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var coffeeModel: CoffeeViewModel
    @State private var recipeList: [SwitchRecipe] = [SwitchRecipe.MOCK_SWITCH_RECIPE, SwitchRecipe.MOCK_SWITCH_RECIPE, SwitchRecipe.MOCK_SWITCH_RECIPE]
    @Bindable private var navigator = NavigationManager.nav
    @State private var searchTerm = ""
    let curMethod: Method
    
    var filteredRecipes: [SwitchRecipe] {
        guard !searchTerm.isEmpty else { return recipeList }
        return recipeList.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
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
                }
                SearchBar(text: $searchTerm, placeholder: "Search Recipes")
                ScrollView {
                    ForEach(filteredRecipes, id: \.self) { recipe in
                        NavigationLink(
                            destination: RecipeView(
                                recipe: recipe,
                                coffee: Coffee.MOCK_COFFEE
                            )
                            .environmentObject(keychainManager)
                            .environmentObject(coffeeModel)
                        ) {
                            RecipeCard(recipe: recipe, coffee: Coffee.MOCK_COFFEE)
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
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        let keychainManager = KeychainManager()
        let coffeeViewModel = CoffeeViewModel()
        RecipeListView(curMethod: Method(id: 1, name: "Pour Over"))
            .environmentObject(keychainManager)
            .environmentObject(coffeeViewModel)
    }
}
