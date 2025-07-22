//
//  RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: RecipeViewModel
    @Bindable private var navigator = NavigationManager.nav
    @State private var searchTerm = ""
    @State private var isShowingCreateRecipeView = false
    @State private var hasApeared: Bool = false
    let curMethod: Method
    
    init(curMethod: Method) {
        self.curMethod = curMethod
    }
    
    var filteredRecipes: [SwitchRecipe] {
        guard !searchTerm.isEmpty else { return viewModel.switchRecipes }
        return viewModel.switchRecipes.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
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
                    CreateRecipeView()
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
                            ForEach(filteredRecipes, id: \.self) { recipe in
                                NavigationLink(
                                    destination: SwitchRecipeView(
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

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    NavigationStack {
        RecipeListView(curMethod: Method.MOCK_METHOD)
            .environmentObject(authViewModel)
    }
}
