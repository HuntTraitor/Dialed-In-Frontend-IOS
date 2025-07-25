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
        VStack {
            HStack {
                Image(systemName: "cup.and.heat.waves.fill")
                    .foregroundColor(Color("background"))
                Text(recipe.method.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 10)
            
            Divider()
                .frame(height: 2)
                .background(Color("background"))
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .opacity(0.8)
            HStack {
                VStack {
                    ImageView(URL(string: recipe.coffee.info.img ?? ""))
                }
                .frame(width: 150, height: 150)
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .italic()
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    HStack {
                        HStack {
                            Image(systemName: "cup.and.heat.waves.fill")
                                .foregroundColor(Color("background"))
                            Text("\(recipe.gramsIn)g")
                        }
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(Color("background"))
                            Text("\(recipe.mlOut)ml")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxHeight: 75) // or whatever value feels right
            }
        }
    }
}

#Preview {
    RecipeCard(recipe: Recipe.switchRecipe(SwitchRecipe.MOCK_SWITCH_RECIPE))
}
