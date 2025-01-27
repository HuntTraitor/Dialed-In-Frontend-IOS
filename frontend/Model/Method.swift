//
//  Method.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/26/25.
//

struct Method: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let img: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case img
    }
}

extension Method {
    static var MOCK_METHOD = Method(id: 1, name: "Mock Method", img: "www.example.com")
}
