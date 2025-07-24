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
        var phases: [Phase]
        
        
        enum CodingKeys: String, CodingKey {
            case name
            case gramsIn = "grams_in"
            case mlOut = "ml_out"
            case phases
        }

        struct Phase: Codable, Hashable {
            var open: Bool
            var time: Int
            var amount: Int
        }
    }
}

//struct V60RecipeInfo: RecipeInfo, Identifiable, Codable, Hashable {
//    var phases: [Phase]
//    struct Phase: Codable, Hashable {
//        var time: Int
//        var amount: Int
//    }
//}

struct SwitchRecipeInput: Codable, Hashable {
    var methodId: Int
    var coffeeId: Int
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
        var phases: [Phase]
        
        enum CodingKeys: String, CodingKey {
            case name
            case gramsIn = "grams_in"
            case mlOut = "ml_out"
            case phases
        }
        
        struct Phase: Codable, Hashable {
            var open: Bool
            var time: Int
            var amount: Int
        }
    }
}

//func mapToSwitchRecipe(_ recipe: Recipe) -> SwitchRecipe? {
//    print(recipe.method.name.lowercased())
//    guard recipe.method.name.lowercased() == "hario switch" else { return nil }
//    
//    do {
//        let data = try JSONSerialization.data(withJSONObject: recipe.info.value, options: [])
//        let decoder = JSONDecoder()
//        let info = try decoder.decode(SwitchRecipe.RecipeInfo.self, from: data)
//
//        return SwitchRecipe(
//            id: recipe.id,
//            userId: recipe.userId,
//            coffee: recipe.coffee,
//            method: recipe.method,
//            info: info
//        )
//    } catch {
//        print("Failed to decode SwitchRecipe info: \(error)")
//        return nil
//    }
//}


//struct MultiSwitchRecipeResponse: Codable {
//    var recipes: [SwitchRecipe]
//}
//
//struct SingleSwitchRecipeResponse: Codable {
//    var recipe: SwitchRecipe
//}
//
//enum FetchSwitchRecipeResult {
//    case recipes([SwitchRecipe])
//    case error([String: Any])
//}
//
//enum PostSwitchRecipeResult {
//    case recipe(SwitchRecipe)
//    case error([String: Any])
//}

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


