//
//  Recipe.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import Foundation

// Wrapper for arbitrary JSON values, Codable conformance
struct RawJSON: Codable {
    let value: Any

    init(value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let dict = try? container.decode([String: RawJSON].self) {
            value = dict.mapValues { $0.value }
        } else if let array = try? container.decode([RawJSON].self) {
            value = array.map { $0.value }
        } else if container.decodeNil() {
            value = NSNull()
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let dict as [String: Any]:
            let encodedDict = dict.mapValues { RawJSON(value: $0) }
            try container.encode(encodedDict)
        case let array as [Any]:
            let encodedArray = array.map { RawJSON(value: $0) }
            try container.encode(encodedArray)
        case is NSNull:
            try container.encodeNil()
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
        }
    }
}

struct Recipe: Identifiable, Codable {
    var id: Int
    var userId: Int
    var coffee: Coffee
    var method: Method
    var info: RawJSON
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
    
    init(from decoder: Decoder) throws {
        // Print the exact JSON this decoder is seeing
        if let jsonData = try? JSONSerialization.data(withJSONObject: decoder.userInfo, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("🔍 JSON being decoded by Recipe: \(jsonString)")
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Print ALL the debug info in one place
        print("=== RECIPE DECODING DEBUG ===")
        print("Available keys: \(container.allKeys)")
        print("Available key raw values: \(container.allKeys.map { $0.rawValue })")
        print("Contains user_id key: \(container.contains(.userId))")
        print("Contains created_at key: \(container.contains(.createdAt))")
        
        // Try to decode each property individually with error handling
        id = try container.decode(Int.self, forKey: .id)
        
        do {
            userId = try container.decode(Int.self, forKey: .userId)
            print("✅ userId decoded successfully: \(userId)")
        } catch {
            print("❌ userId decode failed: \(error)")
            throw error
        }
        

        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        coffee = try container.decode(Coffee.self, forKey: .coffee)
        method = try container.decode(Method.self, forKey: .method)
        info = try container.decode(RawJSON.self, forKey: .info)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        version = try container.decodeIfPresent(Int.self, forKey: .version)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(coffee, forKey: .coffee)
        try container.encode(method, forKey: .method)
        try container.encode(info, forKey: .info)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)   // Add this
        try container.encodeIfPresent(version, forKey: .version)     // Add this
    }
    
    func decodeInfo<T: Decodable>(_ type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: info.value, options: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}

