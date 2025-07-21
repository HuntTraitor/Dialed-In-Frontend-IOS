//
//  Coffee.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/11/25.
//

import Foundation
import UIKit

struct Coffee: Identifiable, Codable, Hashable {
    var id: Int
    var userId: Int
    var info: CoffeeInfo
    var createdAt: String?
    var version: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case info
        case createdAt = "created_at"
        case version
    }
}

struct CoffeeInfo: Codable, Hashable {
    var name: String
    var roaster: String?
    var decaf: Bool
    var region: String?
    var process: String?
    var description: String?
    var originType: OriginType?
    var rating: Rating?
    var roastLevel: RoastLevel?
    var tastingNotes: [TastingNote]?
    var cost: Double?
    var img: String?

    private enum CodingKeys: String, CodingKey {
        case name, roaster, decaf, region, process, description, originType = "origin_type", rating, roastLevel = "roast_level", tastingNotes = "tasting_notes", cost, img
    }
}

enum Rating: Int, Codable {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        self = Rating(rawValue: rawValue) ?? .zero
    }
}

enum TastingNote: String, CaseIterable, Identifiable, Codable {
    case lemon, lime, orange, grapefruit
    case strawberry, raspberry, blueberry
    case raisin, prune
    case apple, peach, pear, grape, melon, pineapple, cherry, coconut, banana

    case acidic, sourAromatics
    case winey, whiskey, fermented

    case oliveOil, raw, greenBeans, peapod, fresh, darkGreen, vegetative

    case stale, cardboard, papery, woody, moldyDamp, mustyDusty, mustyEarthy
    case petroleum, medicinal, rubber, skunky, creosol

    case smoky, ashy, acrid, burnt, tobacco
    case molasses, mapleSyrup, caramelized, brownSugar

    case peanuts, hazelnut, almond
    case chocolate, darkChocolate

    case vanilla, overallSweet, sweetAromatics

    case blackTea, chamomile, rose, jasmine

    case cinnamon, nutmeg, clove, anise, pepper

    var id: String { rawValue }

    var category: String {
        switch self {
        case .lemon, .lime, .orange, .grapefruit,
             .strawberry, .raspberry, .blueberry,
             .raisin, .prune,
             .apple, .peach, .pear, .grape, .melon, .pineapple, .cherry, .coconut, .banana:
            return "Fruity"
        case .acidic, .sourAromatics:
            return "Sour"
        case .winey, .whiskey, .fermented:
            return "Fermented"
        case .oliveOil, .raw, .greenBeans, .peapod, .fresh, .darkGreen, .vegetative:
            return "Green/Vegetative"
        case .stale, .cardboard, .papery, .woody, .moldyDamp, .mustyDusty, .mustyEarthy:
            return "Papery/Musty"
        case .petroleum, .medicinal, .rubber, .skunky, .creosol:
            return "Chemical"
        case .smoky, .ashy, .acrid, .burnt, .tobacco:
            return "Roasted"
        case .molasses, .mapleSyrup, .caramelized, .brownSugar:
            return "Brown Sugar"
        case .peanuts, .hazelnut, .almond:
            return "Nutty"
        case .chocolate, .darkChocolate:
            return "Cocoa"
        case .vanilla, .overallSweet, .sweetAromatics:
            return "Sweet"
        case .blackTea, .chamomile, .rose, .jasmine:
            return "Floral"
        case .cinnamon, .nutmeg, .clove, .anise:
            return "Brown Spice"
        case .pepper:
            return "Spices"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        if let matched = TastingNote.allCases.first(where: { $0.rawValue.lowercased() == rawValue.lowercased() }) {
            self = matched
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid tasting note: \(rawValue)"
            )
        }
    }
}

enum OriginType: String, Codable, Identifiable, Equatable, FixedOption {
    case singleOrigin = "Single Origin"
    case blend = "Blend"
    case unknown = "Unknown"
    
    var id: String { rawValue }
    var displayName: String {rawValue}
    
    static var predefinedOptions: [OriginType] {
        [.singleOrigin, .blend, .unknown]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        if let matched = OriginType.predefinedOptions.first(where: { $0.displayName.lowercased() == rawValue.lowercased() }) {
            self = matched
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid origin type: \(rawValue)"
            )
        }
    }
}


enum RoastLevel: String, Codable, Identifiable, Equatable, FixedOption {
    case light = "Light"
    case mediumLight = "Medium Light"
    case medium = "Medium"
    case mediumDark = "Medium Dark"
    case dark = "Dark"
    case unknown = "Unknown"

    var id: String { rawValue }
    var displayName: String { rawValue }

    static var predefinedOptions: [RoastLevel] {
        [.light, .mediumLight, .medium, .mediumDark, .dark, .unknown]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        if let matched = RoastLevel.predefinedOptions.first(where: { $0.displayName.lowercased() == rawValue.lowercased() }) {
            self = matched
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid roast level: \(rawValue)"
            )
        }
    }
}


struct MultiCoffeeResponse: Codable {
    var coffees: [Coffee]
}

struct SingleCoffeeResponse: Codable {
    var coffee: Coffee
}

struct DeleteCoffeeResponse: Codable {
    var message: String
}

struct CoffeeInput: Identifiable {
    let id: Int?
    let name: String
    let roaster: String?
    let region: String?
    let process: String?
    let description: String?
    let decaf: Bool
    let originType: OriginType?
    let rating: Rating?
    let roastLevel: RoastLevel?
    let tastingNotes: [TastingNote]?
    let cost: Double?
    let img: Data?

    func toMultiPartData(boundary: String) -> Data {
        var data = Data()
        let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8)!

        func appendField(name: String, value: String) {
            data.append(boundaryPrefix)
            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }

        appendField(name: "name", value: name)
        appendField(name: "decaf", value: decaf ? "true" : "false")

        if let region = region {
            appendField(name: "region", value: region)
        }
        
        if let roaster = roaster {
            appendField(name: "roaster", value: roaster)
        }

        if let process = process {
            appendField(name: "process", value: process)
        }

        if let description = description {
            appendField(name: "description", value: description)
        }

        if let originType = originType {
            appendField(name: "origin_type", value: originType.displayName)
        }

        if let rating = rating {
            appendField(name: "rating", value: String(rating.rawValue))
        }

        if let roastLevel = roastLevel {
            appendField(name: "roast_level", value: roastLevel.displayName)
        }

        if let tastingNotes = tastingNotes {
            for note in tastingNotes {
                appendField(name: "tasting_notes", value: note.rawValue)
            }
        }

        if let cost = cost {
            appendField(name: "cost", value: String(format: "%.2f", cost))
        }

        if let img = img {
            data.append(boundaryPrefix)
            data.append("Content-Disposition: form-data; name=\"img\"; filename=\"coffee.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(img)
            data.append("\r\n".data(using: .utf8)!)
        }

        // Closing boundary
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return data
    }
}



extension Coffee {
    static var MOCK_COFFEE = Coffee(
        id: 1,
        userId: 123, // example user id, add if you want
        info: CoffeeInfo(
            name: "Milky Cake",
            roaster: "Dak",
            decaf: false,
            region: "Columbia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            originType: .singleOrigin,
            rating: .four,
            roastLevel: .medium,
            tastingNotes: [.caramelized],
            cost: 24.99,
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        createdAt: nil,
        version: nil
    )
    
    static var MOCK_COFFEE_INPUT = CoffeeInput(
        id: nil,
        name: "Milky Cake",
        roaster: "Dak",
        region: "Columbia",
        process: "Thermal Shock",
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        decaf: false,
        originType: .singleOrigin,
        rating: .four,
        roastLevel: .medium,
        tastingNotes: [.caramelized, .chocolate, .vanilla],
        cost: 24.99,
        img: nil
    )
    
    static var MOCK_NOTHING_COFFEE = Coffee(
        id: 1,
        userId: 123,
        info: CoffeeInfo(
            name: "Nothing Coffee",
            decaf: false
        ),
        createdAt: nil,
        version: nil
    )
}

extension Coffee {
    static var MOCK_COFFEES = [
            Coffee(
                id: 1,
                userId: 123,
                info: CoffeeInfo(
                    name: "Milky Cake",
                    roaster: "Dak Coffee",
                    decaf: false,
                    region: "Columbia",
                    process: "Thermal Shock",
                    description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
                    originType: .singleOrigin,
                    rating: .five,
                    roastLevel: .medium,
                    tastingNotes: [.caramelized, .chocolate, .vanilla],
                    cost: 24.99,
                    img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
                ),
                createdAt: nil,
                version: nil
            ),
            Coffee(
                id: 2,
                userId: 123,
                info: CoffeeInfo(
                    name: "Ethiopian Sunrise",
                    roaster: nil,
                    decaf: false,
                    region: "Ethiopia",
                    process: "Washed",
                    description: "Bright and floral with hints of jasmine and blueberry.",
                    originType: .singleOrigin,
                    rating: .four,
                    roastLevel: .light,
                    tastingNotes: [.jasmine, .blueberry, .lemon],
                    cost: 28.50,
                    img: "https://images.squarespace-cdn.com/content/v1/55ecfe19e4b01667f1806baa/1709056782338-HWNUY7HUQMQ97XAT4RW1/Custom-Label-Coffee_8-12oz.jpg?format=1000w"
                ),
                createdAt: nil,
                version: nil
            ),
            Coffee(
                id: 3,
                userId: 123,
                info: CoffeeInfo(
                    name: "Guatemalan Classic",
                    roaster: nil,
                    decaf: false,
                    region: "Guatemala",
                    process: "Natural",
                    description: "Rich and balanced with notes of chocolate and nuts.",
                    originType: .blend,
                    rating: .three,
                    roastLevel: .mediumDark,
                    tastingNotes: [.chocolate, .hazelnut, .almond],
                    cost: 19.99,
                    img: nil
                ),
                createdAt: nil,
                version: nil
            ),
            Coffee(
                id: 4,
                userId: 123,
                info: CoffeeInfo(
                    name: "Indonesian Earth",
                    roaster: nil,
                    decaf: true,
                    region: "Sumatra",
                    process: "Anaerobic Natural",
                    description: "Earthy and bold with smoky undertones.",
                    originType: .singleOrigin,
                    rating: .four,
                    roastLevel: .dark,
                    tastingNotes: [.smoky, .mustyEarthy, .darkChocolate],
                    cost: 22.75,
                    img: nil
                ),
                createdAt: nil,
                version: nil
            ),
            Coffee(
                id: 5,
                userId: 123,
                info: CoffeeInfo(
                    name: "Nothing Coffee",
                    roaster: nil,
                    decaf: true,
                    region: nil,
                    process: nil,
                    description: nil,
                    originType: nil,
                    rating: nil,
                    roastLevel: nil,
                    tastingNotes: nil,
                    cost: nil,
                    img: nil
                ),
                createdAt: nil,
                version: nil
            )
        ]
}
