//
//  V60Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import Foundation
import UIKit

struct V60Recipe: Identifiable, Codable, Hashable {
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
        var phases: [V60Phase]
        
            
        enum CodingKeys: String, CodingKey {
            case name
            case gramsIn = "grams_in"
            case mlOut = "ml_out"
            case phases
        }
    }
}

struct V60RecipeInput: Codable, Hashable, RecipeInput {
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
        var phases: [V60Phase]
        
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

struct V60Phase: Codable, Hashable {
    var time: Int
    var amount: Int
}

extension V60Recipe {
    static var MOCK_V60_RECIPE = V60Recipe(
        id: 1,
        userId: User.MOCK_USER.id,
        coffee: Coffee.MOCK_COFFEE,
        method: Method.MOCK_METHOD,
        info: RecipeInfo(
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
    
    static var MOCK_V60_RECIPE_INPUT = V60RecipeInput(
        methodId: 1,
        coffeeId: Coffee.MOCK_COFFEE.id,
        info: V60RecipeInput.RecipeInfo(
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
    
    static var MOCK_V60_RECIPE_NO_COFFEE = V60Recipe(
        id: 1,
        userId: User.MOCK_USER.id,
        method: Method.MOCK_METHOD,
        info: V60Recipe.RecipeInfo(
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
        V60Recipe(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: RecipeInfo(
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
        V60Recipe(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: RecipeInfo(
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
        V60Recipe(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: RecipeInfo(
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
        V60Recipe(
            id: 1,
            userId: User.MOCK_USER.id,
            coffee: Coffee.MOCK_COFFEE,
            method: Method.MOCK_METHOD,
            info: RecipeInfo(
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




