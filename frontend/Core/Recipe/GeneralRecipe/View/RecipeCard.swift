//
//  RecipeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
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

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
            
            HStack(spacing: 16) {
                ZStack {
                    ImageView(URL(string: recipe.coffee.info.img ?? ""))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
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
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    RecipeCard(recipe: Recipe.switchRecipe(SwitchRecipe.MOCK_SWITCH_RECIPE))
}
