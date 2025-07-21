//
//  RecipeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: SwitchRecipe

    var body: some View {
        let totalTime = recipe.info.phases.reduce(0) { $0 + $1.time }

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

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(Color("background"))
                    Text(String(format: "%d:%02d", totalTime / 60, totalTime % 60))
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.leading, 10)
            }
        }
    }
}

#Preview {
    RecipeCard(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}
