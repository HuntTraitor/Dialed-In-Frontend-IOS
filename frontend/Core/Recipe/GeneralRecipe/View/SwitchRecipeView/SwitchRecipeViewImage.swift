//
//  SwitchRecipeViewImage.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/7/25.
//

import SwiftUI

struct SwitchRecipeViewImage: View {
    var recipe: SwitchRecipe
    
    private func rectangleHeight(for phase: SwitchRecipe.RecipeInfo.Phase, in phases: [SwitchRecipe.RecipeInfo.Phase]) -> CGFloat {
        let totalTime = phases.reduce(0) { $0 + $1.time }
        let phaseRatio = CGFloat(phase.time) / CGFloat(totalTime)
        return 135 * phaseRatio
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                 ForEach(0..<recipe.info.phases.count, id: \.self) { index in
                     Rectangle()
                         .foregroundColor(brownShade(for: index, total: recipe.info.phases.count))
                         .frame(width: 230, height: rectangleHeight(for: recipe.info.phases[index], in: recipe.info.phases))
                 }
             }
             Image("V60 animation logo")
                 .resizable()
                 .frame(width: 230, height: 200)
         }
    }
}

#Preview {
    SwitchRecipeViewImage(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}
