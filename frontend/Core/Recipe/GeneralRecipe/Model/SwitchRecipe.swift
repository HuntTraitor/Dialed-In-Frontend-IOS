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

struct MultiSwitchRecipeResponse: Codable {
    var recipes: [SwitchRecipe]
}

struct SingleSwitchRecipeResponse: Codable {
    var recipe: SwitchRecipe
}

enum FetchSwitchRecipeResult {
    case recipes([SwitchRecipe])
    case error([String: Any])
}

enum PostSwitchRecipeResult {
    case recipe(SwitchRecipe)
    case error([String: Any])
}

extension SwitchRecipe {
    static var MOCK_SWITCH_RECIPE = SwitchRecipe(
        id: 1,
        userId: User.MOCK_USER.id,
        coffee: Coffee.MOCK_COFFEE,
        method: Method.MOCK_METHOD,
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
    
    static var MOCK_SWITCH_RECIPE_INPUT = SwitchRecipeInput(
        methodId: 1,
        coffeeId: Coffee.MOCK_COFFEE.id,
        info: SwitchRecipeInput.RecipeInfo(
            name: "Classic Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                SwitchRecipeInput.RecipeInfo.Phase(open: true, time: 3, amount: 160),
                SwitchRecipeInput.RecipeInfo.Phase(open: false, time: 3, amount: 160),
                SwitchRecipeInput.RecipeInfo.Phase(open: true, time: 3, amount: 0)
            ]
        )
    )        
    
    static var MOCK_SWITCH_RECIPES = [
        SwitchRecipe(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
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
        ),
        SwitchRecipe(
            id: 2,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
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
        ),
        SwitchRecipe(
            id: 3,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
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
        ),
        SwitchRecipe(
            id: 4,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
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
    ]
}


