//
//  V60RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI

struct V60RecipeListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: RecipeViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var searchTerm = ""
    @State private var isShowingCreateRecipeView = false
    @State private var hasApeared: Bool = false
    
    var filteredRecipes: [Binding<V60Recipe>] {
        viewModel.v60Recipes.indices.compactMap { index in
            let recipe = viewModel.v60Recipes[index]
            guard searchTerm.isEmpty || recipe.info.name.localizedCaseInsensitiveContains(searchTerm) else {
                return nil
            }
            return $viewModel.v60Recipes[index]
        }
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
                        NavigationStack {
                            SwitchCreateRecipeView()
                        }
                    }
                }
                
                if viewModel.errorMessage != nil {
                    FetchErrorMessageScreen(errorMessage: viewModel.errorMessage)
                        .scaleEffect(0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 10)
                } else if viewModel.switchRecipes.isEmpty {
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
                                ForEach(filteredRecipes, id: \.wrappedValue.id) { $recipe in
                                    NavigationLink(
                                        destination: V60RecipeView(recipe: recipe)
                                    ) {
                                        RecipeCard(recipe: Binding(
                                            get: { Recipe.v60Recipe($recipe.wrappedValue) },
                                            set: { newValue in
                                                if case let .v60Recipe(updated) = newValue {
                                                    $recipe.wrappedValue = updated
                                                }
                                            }
                                        ))
                                        .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .refreshable {
                                Task {
                                    await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                                }
                            }
                        }
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .task {
                if !hasApeared {
                    await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                    hasApeared = true
                }
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationView {
            V60RecipeListView()
        }
    }
}


