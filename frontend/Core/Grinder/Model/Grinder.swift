//
//  Grinder.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import Foundation
import UIKit

struct Grinder: Identifiable, Codable, Hashable {
    var id: Int
    var userId: Int
    var name: String
    var createdAt: String?
    var version: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case createdAt = "created_at"
        case version
    }
}

struct GrinderInput: Codable {
    let id: Int?
    var name: String
}

struct MultiGrinderResponse: Codable {
    var grinders: [Grinder]
}

struct SingleGrinderResponse: Codable {
    var grinder: Grinder
}

struct DeleteGrinderResponse: Codable {
    var message: String
}

extension Grinder {
    static var MOCK_GRINDERS: [Grinder] {
        [
            Grinder(id: 1, userId: 1, name: "Baratza Encore", createdAt: "2026-01-10T08:00:00Z", version: "1.0"),
            Grinder(id: 2, userId: 1, name: "Comandante C40", createdAt: "2026-01-15T09:30:00Z", version: "2.1"),
            Grinder(id: 3, userId: 1, name: "1Zpresso JX-Pro", createdAt: "2026-02-01T11:00:00Z", version: "1.5"),
            Grinder(id: 4, userId: 1, name: "Niche Zero", createdAt: "2026-02-20T14:00:00Z", version: "3.0"),
            Grinder(id: 5, userId: 1, name: "Fellow Ode Gen 2", createdAt: "2026-03-01T10:00:00Z", version: "2.0"),
        ]
    }

    static var MOCK_GRINDER: Grinder {
        Grinder(id: 1, userId: 1, name: "Baratza Encore", createdAt: "2026-01-10T08:00:00Z", version: "1.0")
    }
}

extension GrinderInput {
    static var MOCK_GRINDER_INPUT: GrinderInput {
        GrinderInput(id: 1, name: "Baratza Encore")
    }
}
