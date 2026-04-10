//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import Foundation
import UIKit

struct SwitchInfo: RecipeInfo {
    var name: String
    var gramsIn: Int
    var mlOut: Int
    var waterTemp: String
    var grindSize: String?
    var phases: [SwitchPhase]
}

// MARK: - Phase
struct SwitchPhase: Codable, Hashable {
    var open: Bool
    var time: Int
    var amount: Int
}

extension BaseRecipe where Info == SwitchInfo {
    static var MOCK_SWITCH_RECIPE = BaseRecipe<SwitchInfo>(
        id: 1,
        userId: User.MOCK_USER.id,
        coffee: Coffee.MOCK_COFFEE,
        grinder: Grinder.MOCK_GRINDER,
        method: Method.MOCK_METHOD,
        info: SwitchInfo(
            name: "Classic Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            waterTemp: "100°C",
            phases: [
                SwitchPhase(open: true, time: 45, amount: 160),
                SwitchPhase(open: false, time: 75, amount: 160),
                SwitchPhase(open: true, time: 60, amount: 0)
            ]
        )
    )
    
    static var MOCK_SWITCH_RECIPE_INPUT = BaseRecipeInput<SwitchInfo>(
        methodId: 1,
        coffeeId: Coffee.MOCK_COFFEE.id,
        info: SwitchInfo(
            name: "Classic Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            waterTemp: "100°C",
            phases: [
                SwitchPhase(open: true, time: 3, amount: 160),
                SwitchPhase(open: false, time: 3, amount: 160),
                SwitchPhase(open: true, time: 3, amount: 0)
            ]
        )
    )
    
    static var MOCK_SWITCH_RECIPE_NO_COFFEE = BaseRecipe<SwitchInfo>(
        id: 1,
        userId: User.MOCK_USER.id,
        method: Method.MOCK_METHOD,
        info: SwitchInfo(
            name: "Classic Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            waterTemp: "100°C",
            phases: [
                SwitchPhase(open: true, time: 3, amount: 160),
                SwitchPhase(open: false, time: 3, amount: 160),
                SwitchPhase(open: true, time: 3, amount: 0)
            ]
        )
    )
    
    static var MOCK_SWITCH_RECIPES = [
        BaseRecipe<SwitchInfo>(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: SwitchInfo(
                name: "Classic Switch Recipe",
                gramsIn: 20,
                mlOut: 320,
                waterTemp: "100°C",
                phases: [
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
                ]
            )
        ),
        BaseRecipe<SwitchInfo>(
            id: 2,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: SwitchInfo(
                name: "Classic Switch Recipe",
                gramsIn: 20,
                mlOut: 320,
                waterTemp: "100°C",
                phases: [
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
                ]
            )
        ),
        BaseRecipe<SwitchInfo>(
            id: 3,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: SwitchInfo(
                name: "Classic Switch Recipe",
                gramsIn: 20,
                mlOut: 320,
                waterTemp: "100°C",
                phases: [
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
                ]
            )
        ),
        BaseRecipe<SwitchInfo>(
            id: 4,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: SwitchInfo(
                name: "Classic Switch Recipe",
                gramsIn: 20,
                mlOut: 320,
                waterTemp: "100°C",
                phases: [
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
                ]
            )
        )
    ]
}

extension BaseRecipe where Info == SwitchInfo {
    static var COFFEE_CHRONICLER_RECIPE = BaseRecipe<SwitchInfo>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.SWITCH,
        info: SwitchInfo(
            name: "Coffee Chronicler Hario Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            waterTemp: "100°C",
            phases: [
                SwitchPhase(open: true, time: 45, amount: 160),
                SwitchPhase(open: false, time: 75, amount: 160),
                SwitchPhase(open: true, time: 60, amount: 0)
            ]
        )
    )
    
    static var SPROMETHEUS_RECIPE = BaseRecipe<SwitchInfo>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.SWITCH,
        info: SwitchInfo(
            name: "The Real Sprometheus Method",
            gramsIn: 18,
            mlOut: 288,
            waterTemp: "100°C",
            phases: [
                SwitchPhase(open: true, time: 45, amount: 72),
                SwitchPhase(open: false, time: 25, amount: 72),
                SwitchPhase(open: true, time: 30, amount: 0),
                SwitchPhase(open: false, time: 25, amount: 72),
                SwitchPhase(open: true, time: 30, amount: 0),
                SwitchPhase(open: false, time: 25, amount: 72),
                SwitchPhase(open: true, time: 30, amount: 0),
            ]
        )
    )
}


