//
//  Method.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

struct Method: Identifiable, Codable, Hashable {
    let id: Int
    let type: MethodType
    let createdAt: String?

    var name: String {
        type.rawValue
    }

    enum MethodType: String, Codable, Hashable {
        case harioSwitch = "Hario Switch"
        case v60 = "V60"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
    }

    init(id: Int, type: MethodType, createdAt: String?) {
        self.id = id
        self.type = type
        self.createdAt = createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        let name = try container.decode(String.self, forKey: .name)
        guard let methodType = MethodType(rawValue: name) else {
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Invalid method name: \(name)")
        }
        type = methodType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encode(type.rawValue, forKey: .name)
    }
}



struct MethodResponse: Codable {
    let methods: [Method]
}

extension Method {
    static var MOCK_METHOD = Method(id: 2, type: .harioSwitch, createdAt: "2025-07-17T17:53:48Z")

    static var MOCK_METHODS: [Method] = [
        Method(id: 1, type: .v60, createdAt: "2025-07-17T17:53:48Z"),
        Method(id: 2, type: .harioSwitch, createdAt: "2025-07-17T17:53:48Z")
    ]
}
