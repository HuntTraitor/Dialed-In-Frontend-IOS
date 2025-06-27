//
//  V60Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/27/25.
//

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
