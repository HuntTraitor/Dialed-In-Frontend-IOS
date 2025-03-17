//
//  RecipeAnimation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/17/25.
//

import SwiftUI

struct RecipeAnimation: View {
    let recipe: SwitchRecipe
    var body: some View {
        VStack(spacing: 0) {
            PhaseView(recipe: recipe, phase: 3)
            Image(systemName: "play.fill")
                .foregroundColor(Color("background"))
                .font(.system(size: 50))
                .padding(.top, 50)
            Spacer()
        }
    }
}

#Preview {
    RecipeAnimation(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}

