//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

public struct RecipeView: View {
    public var body: some View {
        Text("Recipe for: Coffee")
        if case let .switchRecipe(recipeData) = Recipe.MOCK_SWITCH_RECIPE.info,
           let firstPhase = recipeData.phases[1] {
            CountdownTimer(seconds: firstPhase.time)
        }
    }
}

#Preview {
    RecipeView()
}
