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
        var coffee: Coffee?
        var method: Method
        var info: RecipeInfo
        var createdAt: String?
        var version: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case coffee
        case method
        case info
        case createdAt = "created_at"
        case version
    }
    
    struct RecipeInfo: Codable, Hashable{
        var name: String
        var gramsIn: Int
        var mlOut: Int
        var phases: [SwitchPhase]
        
            
        enum CodingKeys: String, CodingKey {
            case name
            case gramsIn = "grams_in"
            case mlOut = "ml_out"
            case phases
        }
    }
}

struct SwitchRecipeInput: Codable, Hashable, RecipeInput {
    var methodId: Int
    var coffeeId: Int?
    var info: RecipeInfo
    
    
    enum CodingKeys: String, CodingKey {
        case methodId = "method_id"
        case coffeeId = "coffee_id"
        case info
    }
    
    struct RecipeInfo: Codable, Hashable {
        var name: String
        var gramsIn: Int
        var mlOut: Int
        var phases: [SwitchPhase]
        
        enum CodingKeys: String, CodingKey {
            case name
            case gramsIn = "grams_in"
            case mlOut = "ml_out"
            case phases
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(methodId, forKey: .methodId)
        try container.encode(info, forKey: .info)

        if let coffeeId {
            try container.encode(coffeeId, forKey: .coffeeId)
        } else {
            try container.encodeNil(forKey: .coffeeId)
        }
    }
}

struct SwitchPhase: Codable, Hashable {
    var open: Bool
    var time: Int
    var amount: Int
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
                SwitchPhase(open: true, time: 45, amount: 160),
                SwitchPhase(open: false, time: 75, amount: 160),
                SwitchPhase(open: true, time: 60, amount: 0)
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
                SwitchPhase(open: true, time: 3, amount: 160),
                SwitchPhase(open: false, time: 3, amount: 160),
                SwitchPhase(open: true, time: 3, amount: 0)
            ]
        )
    )
    
    static var MOCK_SWITCH_RECIPE_NO_COFFEE = SwitchRecipe(
        id: 1,
        userId: User.MOCK_USER.id,
        method: Method.MOCK_METHOD,
        info: SwitchRecipe.RecipeInfo(
            name: "Classic Switch Recipe",
            gramsIn: 20,
            mlOut: 320,
            phases: [
                SwitchPhase(open: true, time: 3, amount: 160),
                SwitchPhase(open: false, time: 3, amount: 160),
                SwitchPhase(open: true, time: 3, amount: 0)
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
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
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
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
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
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
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
                    SwitchPhase(open: true, time: 3, amount: 160),
                    SwitchPhase(open: false, time: 3, amount: 160),
                    SwitchPhase(open: true, time: 3, amount: 0)
                ]
            )
        )
    ]
}


