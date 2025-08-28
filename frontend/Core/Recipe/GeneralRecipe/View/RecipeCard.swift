//
//  RecipeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeCard: View {
    @Binding var recipe: Recipe
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: RecipeViewModel
    @State private var showEditSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var recipeToDelete: Recipe?
    
    @ViewBuilder
    private var editSheetContent: some View {
        if let binding = $recipe.switchRecipeBinding {
            NavigationView {
                SwitchEditRecipeView(recipe: binding)
                    .navigationTitle("Edit Recipe")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "cup.and.heat.waves.fill")
                    .foregroundColor(.brown)
                    .font(.title2)
                
                Text(recipe.method.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.brown)
                
                Spacer()
                
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                    }
                    
                    
                    Button(role: .destructive) {
                        recipeToDelete = recipe
                        showDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .frame(width: 44, height: 44)
                        .padding(.trailing, 20)
                        .foregroundColor(Color("background"))
                }

            }
            .padding(.horizontal, 16)
            
            Divider()
            
            HStack(spacing: 16) {
                ZStack {
                    if let imgString = recipe.coffee.info.img, !imgString.isEmpty, let url = URL(string: imgString) {
                        ImageView(url)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .scaledToFit()
                    } else {
                        Image("No Image")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .frame(width: 120, height: 120)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(recipe.coffee.info.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "scalemass")
                                    .font(.caption)
                                Text("\(recipe.gramsIn)g")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.brown)
                            
                            Text("Coffee")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "drop.fill")
                                    .font(.caption)
                                Text("\(recipe.mlOut)ml")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.blue)
                            
                            Text("Output")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        // Ratio display
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "percent")
                                    .font(.caption)
                                Text("1:\(Int(Double(recipe.mlOut) / Double(recipe.gramsIn)))")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.orange)
                            
                            Text("Ratio")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $showEditSheet) {
            editSheetContent
        }
        .alert("Are you sure you want to delete this recipe?", isPresented: $showDeleteAlert, presenting: recipeToDelete) { recipe in
            Button("Yes", role: .destructive) {
                Task {
                    await viewModel.deleteRecipe(recipeId: recipe.id, token: authViewModel.token ?? "")
                    await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

extension Binding where Value == Recipe {
    var switchRecipeBinding: Binding<SwitchRecipe>? {
        guard case .switchRecipe = wrappedValue else { return nil }
        return Binding<SwitchRecipe>(
            get: {
                if case .switchRecipe(let sr) = self.wrappedValue {
                    return sr
                }
                fatalError("Unexpected enum case")
            },
            set: { newValue in
                self.wrappedValue = .switchRecipe(newValue)
            }
        )
    }
}


#Preview {
    @Previewable @State var recipe = Recipe.switchRecipe(SwitchRecipe.MOCK_SWITCH_RECIPE)
    PreviewWrapper {
        RecipeCard(recipe: $recipe)
    }
}
