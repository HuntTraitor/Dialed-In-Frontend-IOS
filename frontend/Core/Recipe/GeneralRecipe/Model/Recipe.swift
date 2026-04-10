//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

// MARK: - RecipeInfo Protocol

protocol RecipeInfo: Codable, Hashable {
    var name: String { get }
    var gramsIn: Int { get }
    var mlOut: Int { get }
    var waterTemp: String { get }
    var grindSize: String? { get }
}

// MARK: - RecipeData Protocol

protocol RecipeData: Codable {
    associatedtype Info: RecipeInfo
    var id: Int { get }
    var info: Info { get }
    var coffee: Coffee? { get }
    var grinder: Grinder? { get }
    var method: Method { get }
}

// MARK: - Base Recipe

struct BaseRecipe<Info: RecipeInfo>: Identifiable, Codable, Hashable, RecipeData {
    var id: Int
    var userId: Int
    var coffee: Coffee?
    var grinder: Grinder?
    var method: Method
    var info: Info
    var createdAt: String?
    var version: Int?
}

// MARK: - Base Recipe Input

struct BaseRecipeInput<Info: RecipeInfo>: Codable, Hashable, RecipeInput {
    var methodId: Int
    var coffeeId: Int?
    var grinderId: Int?
    var info: Info
}

// MARK: - RecipeInput Protocol

protocol RecipeInput: Codable {
    var methodId: Int { get }
    var coffeeId: Int? { get }
    var grinderId: Int? { get }
}

// MARK: - Recipe Enum

private struct RecipeEnvelope: Decodable {
    struct MethodName: Decodable { let name: String }
    let method: MethodName
}

enum Recipe: Identifiable, Codable {
    case switchRecipe(BaseRecipe<SwitchInfo>)
    case v60Recipe(BaseRecipe<V60Info>)
    
    private var base: any RecipeData {
        switch self {
        case .switchRecipe(let data): return data
        case .v60Recipe(let data): return data
        }
    }
    
    var id: Int { base.id }
    var name: String { base.info.name }
    var coffee: Coffee? { base.coffee }
    var grinder: Grinder? { base.grinder }
    var method: Method { base.method }
    var gramsIn: Int { base.info.gramsIn }
    var mlOut: Int { base.info.mlOut }
    var waterTemp: String { base.info.waterTemp }
    var grindSize: String? { base.info.grindSize }
    
    init(from decoder: Decoder) throws {
        let envelope = try RecipeEnvelope(from: decoder)
        
        switch envelope.method.name {
        case "Hario Switch":
            self = .switchRecipe(try BaseRecipe<SwitchInfo>(from: decoder))
        case "V60":
            self = .v60Recipe(try BaseRecipe<V60Info>(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                in: try decoder.singleValueContainer(),
                debugDescription: "Unknown method: \(envelope.method.name)"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .switchRecipe(let data): try data.encode(to: encoder)
        case .v60Recipe(let data): try data.self.encode(to: encoder)
        }
    }
    
 }
