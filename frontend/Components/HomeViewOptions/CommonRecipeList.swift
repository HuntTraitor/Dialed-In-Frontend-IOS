//
//  CommonRecipeList.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/28/25.
//

import SwiftUI

struct CommonRecipeList: View {
    var body: some View {
        VStack(spacing: 12) {
            CommonRecipeView(
                recipe: .switchRecipe(SwitchRecipe.COFFEE_CHRONICLER_RECIPE),
                title: "Coffee Chronicler Hario Switch",
                description: "This Hario Switch recipe uses a simple two-pour hybrid technique that combines pour-over clarity with immersion body. The first open-valve burst pour extracts bright, fruity notes, while the second pour and closed-switch steep create deeper sweetness and consistency. It’s easy to memorize, flexible across doses and ratios, and works well with a wide range of beans and grinders. Expect a lively, fruit-forward cup with a smooth, rounded finish.",
                link: "https://www.youtube.com/watch?v=68ZOXrXbVHc"
            )
            CommonRecipeView(
                recipe: .switchRecipe(SwitchRecipe.COFFEE_CHRONICLER_RECIPE),
                title: "Coffee Chronicler Hario Switch",
                description: "This Hario Switch recipe uses a simple two-pour hybrid technique that combines pour-over clarity with immersion body. The first open-valve burst pour extracts bright, fruity notes, while the second pour and closed-switch steep create deeper sweetness and consistency. It’s easy to memorize, flexible across doses and ratios, and works well with a wide range of beans and grinders. Expect a lively, fruit-forward cup with a smooth, rounded finish.",
                link: "https://www.youtube.com/watch?v=68ZOXrXbVHc"
            )
            CommonRecipeView(
                recipe: .switchRecipe(SwitchRecipe.COFFEE_CHRONICLER_RECIPE),
                title: "Coffee Chronicler Hario Switch",
                description: "This Hario Switch recipe uses a simple two-pour hybrid technique that combines pour-over clarity with immersion body. The first open-valve burst pour extracts bright, fruity notes, while the second pour and closed-switch steep create deeper sweetness and consistency. It’s easy to memorize, flexible across doses and ratios, and works well with a wide range of beans and grinders. Expect a lively, fruit-forward cup with a smooth, rounded finish.",
                link: "https://www.youtube.com/watch?v=68ZOXrXbVHc"
            )
        }
    }
}

#Preview {
    PreviewWrapper {
        CommonRecipeList()
    }
}

