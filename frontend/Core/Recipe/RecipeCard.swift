//
//  RecipeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: SwitchRecipe
    var coffee: Coffee
    var body: some View {
        let totalTime = recipe.info.phases.reduce(0) { $0 + $1.value.time }
        HStack {
            VStack {
                ImageView(URL(string: coffee.img!))
                Text(coffee.name)
                    .bold()
            }
            VStack {
                Text(recipe.info.name)
                    .italic()
                    .bold()
                    .padding(.bottom, 10)
                HStack {
                    Image(systemName: "cup.and.heat.waves.fill")
                        .foregroundColor(Color("background"))
                    Text("\(recipe.info.gramsIn)g")
                    Spacer()
                    Image(systemName: "drop.fill")
                        .foregroundColor(Color("background"))
                    Text("\(recipe.info.mlOut)ml")
                }
                .padding(.bottom, 10)
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(Color("background"))
                    Text(String(format: "%d:%02d", totalTime / 60, totalTime % 60))
                        .bold()
                }
            }
        }
    }
}

#Preview {
    RecipeCard(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE, coffee: Coffee.MOCK_COFFEE)
}
