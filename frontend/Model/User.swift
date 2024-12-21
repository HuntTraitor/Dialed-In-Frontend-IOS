//
//  User.swift
//  frontend
//
//  Created by Hunter Tratar on 12/11/24.
//

import Foundation

enum CreateUserResult {
    case user(User)
    case error([String: Any])
}

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let activated: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case createdAt = "created_at"
        case activated
    }
}

let emailRX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

extension User {
    static var MOCK_USER = User(id: 1, name: "Hunter Tratar", email: "hunterrrisatratar@gmail.com", createdAt: "2024-12-11T23:04:05Z", activated: false)
}
