//
//  Token.swift
//  frontend
//
//  Created by Hunter Tratar on 12/26/24.
//

import Foundation

enum SignInResult {
    case token(Token)
    case error([String: Any])
}

struct Token: Codable {
    var token: String
    var expiry: String
}

extension Token {
    static var MOCK_TOKEN = Token(token: "12345678", expiry: "2025-01-10T20:36:21.010464673Z")
}
