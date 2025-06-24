//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import Foundation
import UIKit

struct SwitchRecipe: Identifiable, Codable, Hashable {
    var id: Int
    var userId: Int
    var coffee: Coffee
    var method: Method
    var info: RecipeInfo

    struct RecipeInfo: Codable, Hashable {
        var name: String
        var gramsIn: Int
        var mlOut: Int
        var phases: [Phase]

        struct Phase: Codable, Hashable {
            var open: Bool
            var time: Int
            var amount: Int
        }
    }
}

struct SwitchRecipeInput: Codable, Hashable {
    var methodId: Int
    var coffeeId: Int
    var info: RecipeInfo
    
    struct RecipeInfo: Codable, Hashable {
        var name: String
        var gramsIn: Int
        var mlOut: Int
        var phases: [Phase]
        
        struct Phase: Codable, Hashable {
            var open: Bool
            var time: Int
            var amount: Int
        }
    }
}

struct V60Recipe: Identifiable, Codable, Hashable {
    var id: Int
    var coffeeId: Int
    var methodId: Int
    var info: RecipeInfo
    
    struct RecipeInfo: Codable, Hashable {
        var time: Int
        var amount: Int
    }
}

extension SwitchRecipe {
    static var MOCK_SWITCH_RECIPE = SwitchRecipe(
        id: 1,
        userId: 101,
        coffee: Coffee.MOCK_COFFEE,
        method: Method(
            id: 1,
            name: "Hario Switch"
        ),
        info: RecipeInfo(
            name: "Classic Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                RecipeInfo.Phase(open: true, time: 3, amount: 160),
                RecipeInfo.Phase(open: false, time: 3, amount: 160),
                RecipeInfo.Phase(open: true, time: 3, amount: 0)
            ]
        )
    )
}


