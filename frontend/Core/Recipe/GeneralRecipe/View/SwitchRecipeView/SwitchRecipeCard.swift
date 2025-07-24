//
//  RecipeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct SwitchRecipeCard: View {
    var recipe: SwitchRecipe
    
    var body: some View {
        HStack {
            VStack {
                ImageView(URL(string: recipe.coffee.info.img ?? ""))
                Text(recipe.coffee.info.name)
                    .bold()
            }

            VStack(alignment: .leading) {
                Text(recipe.info.name)
                    .italic()
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)

                HStack {
                    HStack {
                        Image(systemName: "cup.and.heat.waves.fill")
                            .foregroundColor(Color("background"))
                        Text("\(recipe.info.gramsIn)g")
                    }
                    .padding(.leading, 15)
                    Spacer()
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(Color("background"))
                        Text("\(recipe.info.mlOut)ml")
                    }
                    .padding(.trailing, 10)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    SwitchRecipeCard(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}
