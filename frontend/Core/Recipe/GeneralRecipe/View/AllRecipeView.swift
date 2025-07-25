//
//  AllRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/24/25.
//

import SwiftUI

struct AllRecipeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: RecipeViewModel
    @State private var searchTerm = ""
    @State private var isShowingCreateRecipeView = false
    @State private var hasApeared: Bool = false
    
    var filteredRecipes: [Recipe] {
        guard !searchTerm.isEmpty else { return viewModel.allRecipes }
        return viewModel.allRecipes.filter {$0.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
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
                        //                    CreateSwitchRecipeView()
                    }
                }
                
                if viewModel.errorMessage != nil {
                    FetchErrorMessageScreen(errorMessage: viewModel.errorMessage)
                        .scaleEffect(0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 10)
                } else if viewModel.allRecipes.isEmpty {
                    NoResultsFound(itemName: "recipe", systemImage: "book.pages")
                        .scaleEffect(0.8)
                        .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        SearchBar(text: $searchTerm, placeholder: "Search Recipes")
                            .padding(.horizontal, 10)
                        if filteredRecipes.isEmpty && !searchTerm.isEmpty {
                            NoSearchResultsFound(itemName: "recipe")
                                .scaleEffect(0.8)
                                .offset(y: -(UIScreen.main.bounds.height) * 0.1)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                ForEach(filteredRecipes, id: \.id) { recipe in
                                    NavigationLink(
                                        destination: destinationView(for: recipe)
                                    ) {
                                        recipeCard(for: recipe)
                                            .padding(.vertical, 10)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .addToolbar()
            .task {
                if !hasApeared {
                    await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                    hasApeared = true
                }
            }
        }
    }
}

extension AllRecipeView {
    @ViewBuilder
    func destinationView(for recipe: Recipe) -> some View {
        switch recipe {
        case .switchRecipe(let switchRecipe):
            SwitchRecipeView(recipe: switchRecipe)
        }
    }

    @ViewBuilder
    func recipeCard(for recipe: Recipe) -> some View {
        switch recipe {
        case .switchRecipe(let switchRecipe):
            RecipeCard(recipe: .switchRecipe(switchRecipe))
        }
    }
}


#Preview {
    PreviewWrapper {
        NavigationView {
            AllRecipeView()
        }
    }
}
