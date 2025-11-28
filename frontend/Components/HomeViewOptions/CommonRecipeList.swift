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
                recipe: .v60Recipe(V60Recipe.JAMES_HOFFMAN_RECIPE),
                title: "James Hoffman One Cup",
                description: "This updated 1-cup V60 method uses five controlled 50 g pulses to create even agitation and consistent extraction. A fine grind, 15 g dose, and fresh-off-boil water help maximize sweetness and clarity, especially with lighter roasts. Pours are done in slow circles at about 5 g/sec, allowing the bed to settle between pulses for balanced agitation. The result is a forgiving, repeatable technique that delivers a sweet, clean, and fully extracted cup.",
                link: "https://www.youtube.com/watch?v=1oB1oDrDkHM"
            )
            CommonRecipeView(
                recipe: .v60Recipe(V60Recipe.FOURTOSIX_RECIPE),
                title: "Tetsu Kasuya 4:6 Recipe",
                description: "This basic V60 recipe is built on Tetsu Kasuya’s iconic 4:6 Method, using five equal pours to create a clean, balanced, and flavorful cup. Brewing at a 1:15 ratio with 20 g of coffee and 300 g of water, each 60 g pulse is poured in 10 seconds with 45-second intervals to control sweetness and clarity. The method emphasizes consistency, an even coffee bed, and simple adjustments for different bean types or roast levels. It’s an approachable, reliable technique that highlights your coffee’s natural sweetness and structure.",
                link: "https://beanrockcoffee.com/coffee-recipes/v60-4-6-method-basic/?srsltid=AfmBOoqsVjYtwAGP67bdkOOqO4xtj5RTnshQwgZ8TkyjZp-t1K1hV_fz"
            )
            CommonRecipeView(
                recipe: .v60Recipe(V60Recipe.FIVE_POUR_METHOD),
                title: "Matt Winton Five Pour Method",
                description: "This recipe is Matt Winton’s “5-Pour Method,” a simple and repeatable V60 approach built around five aggressive 60 g pours. Using 20 g of coffee at a 1:15 ratio, each pour begins in the center before widening outward, with the next pulse added as soon as the previous one finishes draining. The method relies on a fairly coarse grind, steady agitation, and gradually cooling water to maximize clarity and highlight delicate aromas. It produces a bright, clean, and exceptionally balanced cup with the signature clarity Winton used in his World Brewers Cup routine.",
                link: "https://www.youtube.com/watch?v=YIC-2nFQ7vM"
            )
            CommonRecipeView(
                recipe: .v60Recipe(V60Recipe.LANCE_HEDRICK_PREFERRED),
                title: "Lance Hedrick Preferred",
                description: "Lance’s current go-to V60 recipe uses 15 g of coffee, a 45 g bloom, and then a single fast pour to 250 g after a long degassing period. This approach minimizes agitation and creates a shorter contact time, targeting a 17–18% extraction that brings out floral, delicate, and nuanced flavors. The method relies on reading the bloom and adjusting timing based on how quickly the bed absorbs water. It’s a simple, forgiving daily recipe that delivers a clean, sweet, and highly aromatic cup without complexity or fuss.",
                link: "https://www.youtube.com/watch?v=wZst-D3eUm0"
            )
            CommonRecipeView(
                recipe: .v60Recipe(V60Recipe.LANCE_HEDRICK_HIGH_EXTRACTION),
                title: "Lance Hedrick High Extraction",
                description: "This high-extraction V60 method uses a double bloom (60 g + 60 g) followed by two larger pours of 100 g each, reaching a total of 320 g of water for 20 g of coffee. Aggressive pouring and high agitation push the extraction above 20%, resulting in a strong, intense, structured cup. It’s best for those who enjoy bold, heavier flavors and higher extraction profiles. While not Lance’s preferred style today, it remains a valid recipe praised by many for its punch and robustness.",
                link: "https://www.youtube.com/watch?v=wZst-D3eUm0"
            )
        }
    }
}

#Preview {
    PreviewWrapper {
        CommonRecipeList()
    }
}

