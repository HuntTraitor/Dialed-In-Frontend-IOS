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
    var name: String
    var roaster: String?
    var decaf: Bool
    var region: Region?
    var process: String?
    var description: String?
    var originType: OriginType?
    var rating: Rating?
    var roastLevel: RoastLevel?
    var tastingNotes: [TastingNote]?
    var cost: Double?
    var img: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, region, process, description, decaf, img
    }
}

// ENUMS ------------------------------------------------------------------------------------------------------------

// TODO add new processes
enum Process: Codable, CaseIterable, Identifiable, Equatable {
    case washed
    case dried
    case roasted
    case custom(String)

    var id: String {
        switch self {
        case .washed: return "Washed"
        case .dried: return "Dried"
        case .roasted: return "Roasted"
        case .custom(let value): return value
        }
    }

    var displayName: String {
        id
    }

    static var allCases: [Process] {
        [.washed, .dried, .roasted]
    }
}

enum Rating: Int, Codable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}

enum TastingNote: String, CaseIterable, Identifiable {
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
}


// TODO add a custom region
enum Region: Hashable, Codable, Identifiable {
    // General countries and known subregions
    case ethiopia, ethiopiaYirgacheffe, ethiopiaSidamo, ethiopiaHarrar
    case kenya, kenyaNyeri, kenyaKiambu
    case rwanda, burundi, tanzania, uganda, drCongo

    case guatemala, guatemalaAntigua, guatemalaHuehuetenango
    case costaRica, costaRicaTarrazu
    case honduras, elSalvador, nicaragua
    case panama, panamaBoquete

    case colombia, colombiaHuila, colombiaNariño, colombiaAntioquia
    case brazil, brazilSulDeMinas, brazilCerrado, brazilMogiana
    case peru, ecuador, bolivia

    case indonesia, indonesiaSumatra, indonesiaJava, indonesiaSulawesi, indonesiaBali
    case vietnam, india, papuaNewGuinea, thailand
    case china, chinaYunnan

    case yemen
    case hawaii, hawaiiKona
    case jamaica, jamaicaBlueMountain
    case galapagos
    case philippines

    case unknown
    case custom(String)

    var id: String { displayName }

    var displayName: String {
        switch self {
        case .ethiopia: return "Ethiopia"
        case .ethiopiaYirgacheffe: return "Ethiopia - Yirgacheffe"
        case .ethiopiaSidamo: return "Ethiopia - Sidamo"
        case .ethiopiaHarrar: return "Ethiopia - Harrar"
        case .kenya: return "Kenya"
        case .kenyaNyeri: return "Kenya - Nyeri"
        case .kenyaKiambu: return "Kenya - Kiambu"
        case .rwanda: return "Rwanda"
        case .burundi: return "Burundi"
        case .tanzania: return "Tanzania"
        case .uganda: return "Uganda"
        case .drCongo: return "DR Congo"

        case .guatemala: return "Guatemala"
        case .guatemalaAntigua: return "Guatemala - Antigua"
        case .guatemalaHuehuetenango: return "Guatemala - Huehuetenango"
        case .costaRica: return "Costa Rica"
        case .costaRicaTarrazu: return "Costa Rica - Tarrazú"
        case .honduras: return "Honduras"
        case .elSalvador: return "El Salvador"
        case .nicaragua: return "Nicaragua"
        case .panama: return "Panama"
        case .panamaBoquete: return "Panama - Boquete"

        case .colombia: return "Colombia"
        case .colombiaHuila: return "Colombia - Huila"
        case .colombiaNariño: return "Colombia - Nariño"
        case .colombiaAntioquia: return "Colombia - Antioquia"
        case .brazil: return "Brazil"
        case .brazilSulDeMinas: return "Brazil - Sul de Minas"
        case .brazilCerrado: return "Brazil - Cerrado"
        case .brazilMogiana: return "Brazil - Mogiana"
        case .peru: return "Peru"
        case .ecuador: return "Ecuador"
        case .bolivia: return "Bolivia"

        case .indonesia: return "Indonesia"
        case .indonesiaSumatra: return "Indonesia - Sumatra"
        case .indonesiaJava: return "Indonesia - Java"
        case .indonesiaSulawesi: return "Indonesia - Sulawesi"
        case .indonesiaBali: return "Indonesia - Bali"
        case .vietnam: return "Vietnam"
        case .india: return "India"
        case .papuaNewGuinea: return "Papua New Guinea"
        case .thailand: return "Thailand"
        case .china: return "China"
        case .chinaYunnan: return "China - Yunnan"

        case .yemen: return "Yemen"
        case .hawaii: return "Hawaii"
        case .hawaiiKona: return "Hawaii - Kona"
        case .jamaica: return "Jamaica"
        case .jamaicaBlueMountain: return "Jamaica - Blue Mountain"
        case .galapagos: return "Ecuador - Galápagos"
        case .philippines: return "Philippines"

        case .unknown: return "Unknown"
        case .custom(let value): return value
        }
    }
}


enum OriginType: String, Codable, CaseIterable, Identifiable {
    case singleOrigin = "Single Origin"
    case blend = "Blend"
    case unknown = "Unknown"

    var id: String { rawValue }
}

enum RoastLevel: String, Codable, CaseIterable, Identifiable {
    case light = "Light"
    case mediumLight = "Medium Light"
    case medium = "Medium"
    case mediumDark = "Medium Dark"
    case dark = "Dark"
    
    var id: String { rawValue }
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
    let region: Region?
    let process: Process?
    let description: String?
    let decaf: Bool
    let originType: OriginType?
    let rating: Rating?
    let roastLevel: RoastLevel?
    let testingNotes: [TastingNote]?
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
            appendField(name: "region", value: region.displayName)
        }
        
        if let roaster = roaster {
            appendField(name: "roaster", value: roaster)
        }

        if let process = process {
            appendField(name: "process", value: process.displayName)
        }

        if let description = description {
            appendField(name: "description", value: description)
        }

        if let originType = originType {
            appendField(name: "originType", value: originType.rawValue)
        }

        if let rating = rating {
            appendField(name: "rating", value: String(rating.rawValue))
        }

        if let roastLevel = roastLevel {
            appendField(name: "roastLevel", value: roastLevel.rawValue)
        }

        if let testingNotes = testingNotes {
            for note in testingNotes {
                appendField(name: "testingNotes[]", value: note.rawValue)
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
        name: "Milky Cake",
        roaster: "Dak",
        decaf: false,
        region: .colombia,
        process: "Thermal Shock",
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        originType: .singleOrigin,
        rating: .four,
        roastLevel: .medium,
        tastingNotes: [.caramelized, .chocolate, .vanilla],
        cost: 24.99,
        img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
    )
    
    static var MOCK_COFFEE_INPUT = CoffeeInput(
        id: nil,
        name: "Milky Cake",
        roaster: "Dak",
        region: .colombia,
        process: .custom("Thermal Shock"),
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        decaf: false,
        originType: .singleOrigin,
        rating: .four,
        roastLevel: .medium,
        testingNotes: [.caramelized, .chocolate, .vanilla],
        cost: 24.99,
        img: nil
    )
}

extension Coffee {
    static var MOCK_COFFEES = [
        Coffee(
            id: 1,
            name: "Milky Cake",
            roaster: "Dak Coffee",
            decaf: false,
            region: .colombia,
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            originType: .singleOrigin,
            rating: .five,
            roastLevel: .medium,
            tastingNotes: [.caramelized, .chocolate, .vanilla],
            cost: 24.99,
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        Coffee(
            id: 2,
            name: "Ethiopian Sunrise",
            decaf: false,
            region: .ethiopiaSidamo,
            process: "Washed",
            description: "Bright and floral with hints of jasmine and blueberry.",
            originType: .singleOrigin,
            rating: .four,
            roastLevel: .light,
            tastingNotes: [.jasmine, .blueberry, .lemon],
            cost: 28.50,
            img: nil
        ),
        Coffee(
            id: 3,
            name: "Guatemalan Classic",
            decaf: false,
            region: .guatemalaAntigua,
            process: "Dried",
            description: "Rich and balanced with notes of chocolate and nuts.",
            originType: .blend,
            rating: .three,
            roastLevel: .mediumDark,
            tastingNotes: [.chocolate, .hazelnut, .almond],
            cost: 19.99,
            img: nil
        ),
        Coffee(
            id: 4,
            name: "Indonesian Earth",
            decaf: true,
            region: .indonesiaSumatra,
            process: "Roasted",
            description: "Earthy and bold with smoky undertones.",
            originType: .singleOrigin,
            rating: .four,
            roastLevel: .dark,
            tastingNotes: [.smoky, .mustyEarthy, .darkChocolate],
            cost: 22.75,
            img: nil
        )
    ]
}
