//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import Foundation
import UIKit

struct Recipe: Identifiable, Codable, Hashable {
    var id: Int
    var userId: Int
    var coffeeId: Int
    var methodId: Int
    var info: RecipeInfo
    
    enum RecipeInfo: Codable, Hashable {
        case switchRecipe(SwitchRecipeData)
        case v60Recipe(V60RecipeData)
        
        enum CodingKeys: String, CodingKey {
            case type, data
        }
        
        enum RecipeType: String, Codable {
            case switchRecipe
            case v60Recipe
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(RecipeType.self, forKey: .type)
            
            switch type {
            case .switchRecipe:
                let data = try container.decode(SwitchRecipeData.self, forKey: .data)
                self = .switchRecipe(data)
            case .v60Recipe:
                let data = try container.decode(V60RecipeData.self, forKey: .data)
                self = .v60Recipe(data)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .switchRecipe(let data):
                try container.encode(RecipeType.switchRecipe, forKey: .type)
                try container.encode(data, forKey: .data)
            case .v60Recipe(let data):
                try container.encode(RecipeType.v60Recipe, forKey: .type)
                try container.encode(data, forKey: .data)
            }
        }
    }
}

struct SwitchRecipeData: Codable, Hashable {
    var gramsIn: Int
    var mlOut: Int
    var phases: [Int: Phase]
    
    struct Phase: Codable, Hashable {
        var open: Bool
        var Time: Int
        var amount: Int
    }
}

struct V60RecipeData: Codable, Hashable {
    var gramsIn: Int
    var mlOut: Int
    var pours: [Pour]
    
    struct Pour: Codable, Hashable {
        var time: Int
        var amount: Int
    }
}


