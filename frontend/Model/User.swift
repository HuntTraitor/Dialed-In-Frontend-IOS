//
//  User.swift
//  frontend
//
//  Created by Hunter Tratar on 12/11/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let activated: Bool
}

let emailRX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

extension User {
    static var MOCK_USER = User(id: 1, name: "Hunter Tratar", email: "hunterrrisatratar@gmail.com", createdAt: "2024-12-11T23:04:05Z", activated: false)
}