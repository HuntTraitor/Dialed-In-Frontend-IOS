//
//  RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

struct SwitchRecipeListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: RecipeViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var searchTerm = ""
    @State private var isShowingCreateRecipeView = false
    @State private var hasAppeared: Bool = false
    
    var filteredRecipes: [Binding<SwitchRecipe>] {
        viewModel.switchRecipes.indices.compactMap { index in
            let recipe = viewModel.switchRecipes[index]
            guard searchTerm.isEmpty || recipe.info.name.localizedCaseInsensitiveContains(searchTerm) else {
                return nil
            }
            return $viewModel.switchRecipes[index]
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
                            SwitchCreateRecipeView()
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
                            } else if viewModel.switchRecipes.isEmpty {
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
                                        destination: SwitchRecipeView(recipe: recipe)
                                    ) {
                                        RecipeCard(recipe: Binding(
                                            get: { Recipe.switchRecipe($recipe.wrappedValue) },
                                            set: { newValue in
                                                if case let .switchRecipe(updated) = newValue {
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
            SwitchRecipeListView()
        }
    }
}
