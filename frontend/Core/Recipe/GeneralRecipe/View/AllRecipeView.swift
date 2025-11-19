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
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var searchTerm = ""
    @State private var hasAppeared: Bool = false
    @State private var navigationPath = NavigationPath()
    @State private var showCreateRecipe = false
    @State private var selectedRecipe: Recipe? = nil
    
    var filteredRecipes: [Binding<Recipe>] {
        viewModel.allRecipes.compactMap { recipe in
            guard searchTerm.isEmpty ||
                  recipe.name.localizedCaseInsensitiveContains(searchTerm) else {
                return nil
            }

            return Binding(
                get: {
                    guard let idx = viewModel.allRecipes.firstIndex(where: { $0.id == recipe.id }) else {
                        return recipe
                    }
                    return viewModel.allRecipes[idx]
                },
                set: { newValue in
                    guard let idx = viewModel.allRecipes.firstIndex(where: { $0.id == recipe.id }) else {
                        return
                    }
                    viewModel.allRecipes[idx] = newValue
                }
            )
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
                        navigationManager.recipesNavigator.append(.createRecipe)
                    } label: {
                        Label("Add New Recipe", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                    .padding(.top, 40)
                    .italic()
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
                            } else if viewModel.allRecipes.isEmpty {
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
                                // Normal / filtered list
                                ForEach(filteredRecipes, id: \.wrappedValue.id) { $recipe in
                                    NavigationLink(
                                        destination: destinationView(for: recipe)
                                    ) {
                                        recipeCard(for: $recipe)
                                            .padding(.vertical, 10)
                                            .background(Color.white)
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

extension AllRecipeView {
    @ViewBuilder
    func destinationView(for recipe: Recipe) -> some View {
        switch recipe {
        case .switchRecipe(let switchRecipe):
            SwitchRecipeView(recipe: switchRecipe)
        case .v60Recipe(let v60Recipe):
            V60RecipeView(recipe: v60Recipe)
        }
    }

    @ViewBuilder
    func recipeCard(for recipe: Binding<Recipe>) -> some View {
        RecipeCard(recipe: recipe)
    }
}

#Preview {
    struct PreviewContainer: View {
        @ObservedObject private var navigationManager = NavigationManager.shared
        
        var body: some View {
            PreviewWrapper {
                NavigationStack(path: $navigationManager.recipesNavigator) {
                    AllRecipeView()
                }
                .appNavigationSupport()
            }
        }
    }
    return PreviewContainer()
}
