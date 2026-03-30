//
//  V60Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import Foundation
import UIKit

struct V60Info: RecipeInfo {
    var name: String
    var gramsIn: Int
    var mlOut: Int
    var phases: [V60Phase]
}

struct V60Phase: Codable, Hashable {
    var time: Int
    var amount: Int
}

extension BaseRecipe where Info == V60Info {
    static var MOCK_V60_RECIPE = BaseRecipe<V60Info>(
        id: 1,
        userId: User.MOCK_USER.id,
        coffee: Coffee.MOCK_COFFEE,
        method: Method.MOCK_METHOD,
        info: V60Info(
            name: "Classic V60 Recipe",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                V60Phase(time: 45, amount: 160),
                V60Phase(time: 75, amount: 160),
                V60Phase(time: 60, amount: 0)
            ]
        )
    )
    
    static var MOCK_V60_RECIPE_INPUT = BaseRecipeInput<V60Info>(
        methodId: 1,
        coffeeId: Coffee.MOCK_COFFEE.id,
        info: V60Info(
            name: "Classic V60 Recipe",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                V60Phase(time: 3, amount: 160),
                V60Phase(time: 3, amount: 160),
                V60Phase(time: 3, amount: 0)
            ]
        )
    )
    
    static var MOCK_V60_RECIPE_NO_COFFEE = BaseRecipe<V60Info>(
        id: 1,
        userId: User.MOCK_USER.id,
        method: Method.MOCK_METHOD,
        info: V60Info(
            name: "Classic V60 Recipe",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                V60Phase(time: 3, amount: 160),
                V60Phase(time: 3, amount: 160),
                V60Phase(time: 3, amount: 0)
            ]
        )
    )
    
    static var MOCK_V60_RECIPES = [
        BaseRecipe<V60Info>(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: V60Info(
                name: "Classic V60 Recipe",
                gramsIn: 20,
                mlOut: 320,
                phases: [
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 0)
                ]
            )
        ),
        BaseRecipe<V60Info>(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: V60Info(
                name: "Classic V60 Recipe",
                gramsIn: 20,
                mlOut: 320,
                phases: [
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 0)
                ]
            )
        ),
        BaseRecipe<V60Info>(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: V60Info(
                name: "Classic V60 Recipe",
                gramsIn: 20,
                mlOut: 320,
                phases: [
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 0)
                ]
            )
        ),
        BaseRecipe<V60Info>(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: V60Info(
                name: "Classic V60 Recipe",
                gramsIn: 20,
                mlOut: 320,
                phases: [
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 160),
                    V60Phase(time: 3, amount: 0)
                ]
            )
        )
    ]
}

extension BaseRecipe where Info == V60Info {
    static var JAMES_HOFFMAN_RECIPE = BaseRecipe<V60Info>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.V60,
        info: V60Info(
            name: "James Hoffman V60 Recipe",
            gramsIn: 15,
            mlOut: 250,
            phases: [
                V60Phase(time: 45, amount: 50),
                V60Phase(time: 20, amount: 50),
                V60Phase(time: 25, amount: 50),
                V60Phase(time: 20, amount: 50),
                V60Phase(time: 70, amount: 50),
            ]
        )
    )
    
    static var FOURTOSIX_RECIPE = BaseRecipe<V60Info>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.V60,
        info: V60Info(
            name: "Tetsu Kasuya 4:6 V60 Recipe",
            gramsIn: 20,
            mlOut: 300,
            phases: [
                V60Phase(time: 45, amount: 60),
                V60Phase(time: 45, amount: 60),
                V60Phase(time: 45, amount: 60),
                V60Phase(time: 45, amount: 60),
                V60Phase(time: 75, amount: 60),
            ]
        )
    )
    
    static var FIVE_POUR_METHOD = BaseRecipe<V60Info>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.V60,
        info: V60Info(
            name: "Matt Winton Five Pour Method",
            gramsIn: 20,
            mlOut: 300,
            phases: [
                V60Phase(time: 35, amount: 60),
                V60Phase(time: 40, amount: 60),
                V60Phase(time: 40, amount: 60),
                V60Phase(time: 40, amount: 60),
                V60Phase(time: 75, amount: 60),
            ]
        )
    )
    
    static var LANCE_HEDRICK_HIGH_EXTRACTION = BaseRecipe<V60Info>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.V60,
        info: V60Info(
            name: "Lance Hedrick High Extraction",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                V60Phase(time: 30, amount: 60),
                V60Phase(time: 30, amount: 60),
                V60Phase(time: 30, amount: 100),
                V60Phase(time: 75, amount: 100),
            ]
        )
    )
    
    static var LANCE_HEDRICK_PREFERRED = BaseRecipe<V60Info>(
        id: -1,
        userId: -1,
        coffee: nil,
        method: Method.V60,
        info: V60Info(
            name: "Lance Hedrick Preferred Method",
            gramsIn: 15,
            mlOut: 250,
            phases: [
                V60Phase(time: 60, amount: 45),
                V60Phase(time: 120, amount: 205)
            ]
        )
    )
}




