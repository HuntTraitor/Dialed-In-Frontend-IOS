//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeView: View {
    let recipe: SwitchRecipe
    var body: some View {
        Text("Information about an individual recipe")
    }
}

#Preview {
    RecipeView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}
