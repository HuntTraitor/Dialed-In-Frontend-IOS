//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

enum Recipe: Identifiable, Codable {
    case switchRecipe(SwitchRecipe)
    case v60Recipe(V60Recipe)

    var id: Int {
        switch self {
        case .switchRecipe(let data): return data.id
        case .v60Recipe(let data): return data.id
        }
    }

    var name: String {
        switch self {
        case .switchRecipe(let data): return data.info.name
        case .v60Recipe(let data): return data.info.name
        }
    }
    
    var coffee: Coffee? {
        switch self {
        case .switchRecipe(let data): return data.coffee
        case .v60Recipe(let data): return data.coffee
        }
    }
    
    var method: Method {
        switch self {
        case .switchRecipe(let data): return data.method
        case .v60Recipe(let data): return data.method
        }
    }
    
    var gramsIn: Int {
        switch self {
        case .switchRecipe(let data): return data.info.gramsIn
        case.v60Recipe(let data): return data.info.gramsIn
        }
    }
    
    var mlOut: Int {
        switch self {
        case .switchRecipe(let data): return data.info.mlOut
        case .v60Recipe(let data): return data.info.mlOut
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    private enum RecipeType: String, Codable {
        case switchRecipe
        case v60Recipe
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Decode raw dictionary
        let rawRecipe: [String: AnyCodable]
        do {
            rawRecipe = try container.decode([String: AnyCodable].self)
        } catch {
            print("❌ Failed to decode rawRecipe")
            throw error
        }

        // Attempt to get method dictionary
        guard let methodValue = rawRecipe["method"]?.value else {
            print("❌ Missing 'method' in rawRecipe")
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Missing method")
        }

        guard let methodDict = methodValue as? [String: AnyCodable] else {
            print("❌ method is not [String: AnyCodable], got: \(type(of: methodValue))")
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "method was not a dictionary")
        }

        guard let nameValue = methodDict["name"]?.value else {
            print("❌ Missing 'name' in methodDict")
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Missing method.name")
        }

        guard let methodName = nameValue as? String else {
            print("❌ method.name is not a String, got: \(type(of: nameValue))")
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "method.name was not a string")
        }

        // Now encode and re-decode safely
        let plainJSON = unwrap(rawRecipe.mapValues { $0.value })
        guard JSONSerialization.isValidJSONObject(plainJSON) else {
            print("❌ Invalid JSON serialization object")
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot re-encode object")
        }

        let jsonData = try JSONSerialization.data(withJSONObject: plainJSON, options: [])
        let decoder = JSONDecoder()

        switch methodName {
        case "Hario Switch":
            do {
                let switchRecipe = try decoder.decode(SwitchRecipe.self, from: jsonData)
                self = .switchRecipe(switchRecipe)
            } catch {
                print("❌ Failed to decode as SwitchRecipe")
                throw error
            }
        
        case "V60":
            do {
                let v60Recipe = try decoder.decode(V60Recipe.self, from: jsonData)
                self = .v60Recipe(v60Recipe)
            } catch {
                print("❌ Failed to decode as V60Recipe")
                throw error
            }
            
        default:
            print("❌ Unknown method: \(methodName)")
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown method \(methodName)")
        }
    }



    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .switchRecipe(let data):
            try container.encode(RecipeType.switchRecipe, forKey: .type)
            try data.encode(to: encoder)
        case .v60Recipe(let data):
            try container.encode(RecipeType.v60Recipe, forKey: .type)
            try data.encode(to: encoder)
        }
    }
}

struct AnyCodable: Codable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let bool as Bool:
            try container.encode(bool)
        case let array as [AnyCodable]:
            try container.encode(array)
        case let dict as [String: AnyCodable]:
            try container.encode(dict)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported value"))
        }
    }
}

func unwrap(_ value: Any) -> Any {
    if let codable = value as? AnyCodable {
        return unwrap(codable.value)
    } else if let dict = value as? [String: Any] {
        return dict.mapValues(unwrap)
    } else if let dict = value as? [String: AnyCodable] {
        return dict.mapValues { unwrap($0.value) }
    } else if let array = value as? [Any] {
        return array.map(unwrap)
    } else if let array = value as? [AnyCodable] {
        return array.map { unwrap($0.value) }
    } else {
        return value
    }
}

protocol RecipeInput: Codable {
    var methodId: Int { get }
    var coffeeId: Int? { get }
}




// Read data[i] -> check the method -> decode it into the method

