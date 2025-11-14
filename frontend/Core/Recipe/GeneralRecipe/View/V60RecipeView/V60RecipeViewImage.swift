//
//  V60RecipeViewImage.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI

struct V60RecipeViewImage: View {
    var recipe: V60Recipe
    
    private func rectangleHeight(for phase: V60Phase, in phases: [V60Phase]) -> CGFloat {
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
    V60RecipeViewImage(recipe: V60Recipe.MOCK_V60_RECIPE)
}

