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
    @State private var hasAppeared: Bool = false
    
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
                // Header
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
                            V60CreateRecipeView()
                        }
                    }
                }
                
                VStack {
                    SearchBar(text: $searchTerm, placeholder: "Search Recipes")
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                    
                    ScrollView {
                        VStack {
                            if let errorMessage = viewModel.errorMessage {
                                FetchErrorMessageScreen(errorMessage: errorMessage)
                                    .scaleEffect(0.9)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 20)
                                    .frame(maxWidth: .infinity)
                            } else if viewModel.v60Recipes.isEmpty {
                                NoResultsFound(itemName: "recipe", systemImage: "book.pages")
                                    .scaleEffect(0.8)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity)
                            } else if filteredRecipes.isEmpty && !searchTerm.isEmpty {
                                NoSearchResultsFound(itemName: "recipe")
                                    .scaleEffect(0.8)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity)
                            } else {
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
                            
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .refreshable {
                        await Task {
                            await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                        }.value
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .task {
                if !hasAppeared {
                    await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                    hasAppeared = true
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
