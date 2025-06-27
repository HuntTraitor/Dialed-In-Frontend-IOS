//
//  Method.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

struct Method: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct MethodResponse: Codable {
    let methods: [Method]
}

extension Method {
    static var MOCK_METHOD = Method(id: 1, name: "Mock Method")
}
