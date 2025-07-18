//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

enum AnyRecipe {
    case generic(Recipe)
    case switchRecipe(SwitchRecipe)
}

struct Recipe: Identifiable, Decodable {
    var id: Int
    var userId: Int
    var coffee: Coffee
    var method: Method
    var info: [String: Any]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case coffee
        case method
        case info
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        coffee = try container.decode(Coffee.self, forKey: .coffee)
        method = try container.decode(Method.self, forKey: .method)

        // Decode `info` manually using nested container
        let infoData = try container.decodeIfPresent(RawJSON.self, forKey: .info)
        info = infoData?.value as? [String: Any] ?? [:]
    }
}

struct RawJSON: Decodable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Bool.self) {
            self.value = value
        } else if let value = try? container.decode(Int.self) {
            self.value = value
        } else if let value = try? container.decode(Double.self) {
            self.value = value
        } else if let value = try? container.decode(String.self) {
            self.value = value
        } else if let value = try? container.decode([String: RawJSON].self) {
            self.value = Dictionary(uniqueKeysWithValues: value.map { ($0.key, $0.value.value) })
        } else if let value = try? container.decode([RawJSON].self) {
            self.value = value.map { $0.value }
        } else if container.decodeNil() {
            self.value = NSNull()
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON type")
        }
    }
}


