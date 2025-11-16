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
    // Fruity – Berry & Red Fruit
    case strawberry, ripeStrawberry, wildStrawberry
    case raspberry, blackRaspberry, blueberry, blackberry
    case boysenberry, mulberry, cranberry
    case redCurrant, blackcurrant, cherry, blackCherry, maraschinoCherry
    case plum, redPlum, prune, raisin
    case dateFruit, pomegranate, gojiBerry

    // Fruity – Citrus
    case lemon, lemonZest, lemonade
    case lime, keyLime
    case orange, bloodOrange, mandarin, tangerine, clementine
    case grapefruit, pinkGrapefruit
    case bergamot, yuzu, citron

    // Fruity – Stone Fruit
    case peach, whitePeach, nectarine
    case apricot, driedApricot
    case yellowPlum, mirabelle, cherryPlum

    // Fruity – Tropical
    case mango, ripeMango, greenMango
    case pineapple, grilledPineapple
    case passionFruit, guava, papaya
    case lychee, jackfruit, dragonFruit, starfruit, kiwi
    case banana, driedBanana, plantain

    // Fruity – Melon & Other
    case watermelon, cantaloupe, honeydew, melonRind
    case apple, redApple, greenApple, bakedApple
    case pear, asianPear, quince
    case fig, freshFig, driedFig
    case grape, whiteGrape, concordGrape

    // Floral
    case jasmine, jasmineTea
    case orangeBlossom, honeysuckle
    case rose, rosePetal, rosewater
    case lavender, violet, elderflower
    case chamomile, hibiscus
    case bergamotBlossom, lily, lilac, acaciaBlossom
    case frangipani, gardenia

    // Sweet – Sugar Browning & Dessert
    case caramel, saltedCaramel
    case toffee, butterscotch
    case cremeBrulee
    case brownSugar, lightBrownSugar, darkBrownSugar
    case molasses, treacle
    case honey, wildflowerHoney, floralHoney
    case mapleSyrup
    case caneSugar, powderedSugar
    case vanilla, vanillaBean
    case marshmallow, nougat, fudge, praline, dulceDeLeche

    // Sweet – Baked Goods
    case milkChocolate, darkChocolate
    case cocoa, cocoaNibs
    case hotChocolate, chocolateSyrup
    case brownie, chocolateCake, chocolateChipCookie
    case shortbread, sugarCookie, butterCookie
    case poundCake, spongeCake
    case cinnamonRoll
    case pastryCream, custard
    case waffle, pancake
    case pieCrust, grahamCracker

    // Nutty & Seeds
    case almond, marzipan
    case hazelnut, filbert
    case peanut, peanutButter
    case pecan, walnut, cashew, macadamia, pistachio, chestnut
    case roastedNuts, toastedAlmond
    case sunflowerSeed, sesameSeed, tahini

    // Cocoa / Chocolatey
    case bittersweetChocolate
    case bakingChocolate
    case dutchCocoa
    case chocolateTruffle
    case chocolateFudge
    case cocoaHusk
    case hotCocoaMix

    // Spices – Sweet & Baking
    case cinnamon, cassia, nutmeg, clove, allspice
    case starAnise, aniseSeed
    case cardamom, greenCardamom, blackCardamom
    case ginger, candiedGinger
    case pumpkinSpice, applePieSpice

    // Spices – Savory & Herbal
    case blackPepper, whitePepper, pinkPeppercorn
    case chili, cayenne, paprika
    case cumin, corianderSeed, fennelSeed, caraway
    case bayLeaf, sage, thyme, rosemary
    case oregano, marjoram, basil, dill, tarragon

    // Herbal / Tea-Like
    case blackTea, earlGrey
    case greenTea, jasmineGreenTea
    case oolong, rooibos
    case chamomileTea
    case mintTea, spearmint, peppermint
    case lemongrass, lemonVerbena
    case herbalInfusion, driedHerbs

    // Fermented / Alcoholic
    case redWine, whiteWine
    case portWine, sherry
    case brandy, cognac
    case rum, spicedRum
    case whiskey, bourbon
    case liqueur, amaretto, kirsch
    case cider, hardCider
    case beer, stout
    case fermentedFruit, overripeFruit

    // Vegetal / Savory
    case tomato, sunDriedTomato
    case bellPepper, greenBellPepper, redBellPepper
    case jalapeno, greenChili
    case cookedVegetables
    case spinach, kale, cabbage, beet, carrot, celery, cucumber, zucchini
    case olive, greenOlive, blackOlive

    // Fresh / Green
    case freshCutGrass
    case greenLeaf
    case alfalfa
    case hay, wetHay
    case teaLeaf
    case eucalyptus
    case pineNeedle
    case resinous, sappy

    // Nutty / Grain / Cereal
    case roastedBarley
    case malt, maltedBarley
    case toastedGrain
    case granola, cereal, bran
    case wheatCracker
    case ryeBread, wholegrainBread, sourdough
    case oatmeal, porridge

    // Roasty / Browned / Smoky
    case lightRoast, mediumRoast, darkRoast
    case toasted, roasted
    case roastedPeanut, roastedAlmond, roastedHazelnut
    case charred, smoky, campfireSmoke
    case pipeTobacco, cigarBox, tobaccoLeaf
    case grilled
    case burntSugar, singedToast

    // Earthy / Mineral
    case earth, dampEarth, pottingSoil
    case forestFloor, leafLitter
    case mushroom, driedMushroom, truffle
    case clay, chalk
    case stone, flint
    case mineral
    case graphite

    // Dairy / Lactonic
    case milk
    case sweetCream, heavyCream
    case condensedMilk, evaporatedMilk
    case butter, brownedButter
    case yogurt, greekYogurt
    case sourCream, buttermilk

    // Dried Fruit & Candied
    case goldenRaisin, sultana
    case driedApple, driedMango
    case candiedOrangePeel, candiedLemonPeel
    case mixedPeel
    case fruitLeather

    // Mouthfeel / Texture
    case thin
    case lightBodied, mediumBodied, fullBodied
    case heavyMouthfeel
    case creamyMouthfeel
    case silky, velvety
    case syrupy, oily, juicy
    case teaLike
    case roundMouthfeel
    case coating

    // Acidity & Overall Impressions
    case brightAcidity, sparklingAcidity
    case lively, crisp, tart, tangy
    case mellowAcidity, softAcidity
    case balanced
    case roundProfile
    case complex, simpleProfile
    case clean, transparent
    case structured
    case elegant, refined
    case bold, intense, delicate

    var id: String { rawValue }

    var category: String {
        switch self {
        // Fruity – Berry & Red Fruit
        case .strawberry, .ripeStrawberry, .wildStrawberry,
             .raspberry, .blackRaspberry, .blueberry, .blackberry,
             .boysenberry, .mulberry, .cranberry,
             .redCurrant, .blackcurrant, .cherry, .blackCherry, .maraschinoCherry,
             .plum, .redPlum, .prune, .raisin,
             .dateFruit, .pomegranate, .gojiBerry:
            return "Fruity - Berry & Red Fruit"

        // Fruity – Citrus
        case .lemon, .lemonZest, .lemonade,
             .lime, .keyLime,
             .orange, .bloodOrange, .mandarin, .tangerine, .clementine,
             .grapefruit, .pinkGrapefruit,
             .bergamot, .yuzu, .citron:
            return "Fruity - Citrus"

        // Fruity – Stone Fruit
        case .peach, .whitePeach, .nectarine,
             .apricot, .driedApricot,
             .yellowPlum, .mirabelle, .cherryPlum:
            return "Fruity - Stone Fruit"

        // Fruity – Tropical
        case .mango, .ripeMango, .greenMango,
             .pineapple, .grilledPineapple,
             .passionFruit, .guava, .papaya,
             .lychee, .jackfruit, .dragonFruit, .starfruit, .kiwi,
             .banana, .driedBanana, .plantain:
            return "Fruity - Tropical"

        // Fruity – Melon & Other
        case .watermelon, .cantaloupe, .honeydew, .melonRind,
             .apple, .redApple, .greenApple, .bakedApple,
             .pear, .asianPear, .quince,
             .fig, .freshFig, .driedFig,
             .grape, .whiteGrape, .concordGrape:
            return "Fruity - Melon & Other"

        // Floral
        case .jasmine, .jasmineTea,
             .orangeBlossom, .honeysuckle,
             .rose, .rosePetal, .rosewater,
             .lavender, .violet, .elderflower,
             .chamomile, .hibiscus,
             .bergamotBlossom, .lily, .lilac, .acaciaBlossom,
             .frangipani, .gardenia:
            return "Floral"

        // Sweet – Sugar Browning & Dessert
        case .caramel, .saltedCaramel,
             .toffee, .butterscotch,
             .cremeBrulee,
             .brownSugar, .lightBrownSugar, .darkBrownSugar,
             .molasses, .treacle,
             .honey, .wildflowerHoney, .floralHoney,
             .mapleSyrup,
             .caneSugar, .powderedSugar,
             .vanilla, .vanillaBean,
             .marshmallow, .nougat, .fudge, .praline, .dulceDeLeche:
            return "Sweet - Sugar Browning & Dessert"

        // Sweet – Baked Goods
        case .milkChocolate, .darkChocolate,
             .cocoa, .cocoaNibs,
             .hotChocolate, .chocolateSyrup,
             .brownie, .chocolateCake, .chocolateChipCookie,
             .shortbread, .sugarCookie, .butterCookie,
             .poundCake, .spongeCake,
             .cinnamonRoll,
             .pastryCream, .custard,
             .waffle, .pancake,
             .pieCrust, .grahamCracker:
            return "Sweet - Baked Goods"

        // Nutty & Seeds
        case .almond, .marzipan,
             .hazelnut, .filbert,
             .peanut, .peanutButter,
             .pecan, .walnut, .cashew, .macadamia, .pistachio, .chestnut,
             .roastedNuts, .toastedAlmond,
             .sunflowerSeed, .sesameSeed, .tahini:
            return "Nutty & Seeds"

        // Cocoa / Chocolatey
        case .bittersweetChocolate,
             .bakingChocolate,
             .dutchCocoa,
             .chocolateTruffle,
             .chocolateFudge,
             .cocoaHusk,
             .hotCocoaMix:
            return "Cocoa / Chocolatey"

        // Spices – Sweet & Baking
        case .cinnamon, .cassia, .nutmeg, .clove, .allspice,
             .starAnise, .aniseSeed,
             .cardamom, .greenCardamom, .blackCardamom,
             .ginger, .candiedGinger,
             .pumpkinSpice, .applePieSpice:
            return "Spices - Sweet & Baking"

        // Spices – Savory & Herbal
        case .blackPepper, .whitePepper, .pinkPeppercorn,
             .chili, .cayenne, .paprika,
             .cumin, .corianderSeed, .fennelSeed, .caraway,
             .bayLeaf, .sage, .thyme, .rosemary,
             .oregano, .marjoram, .basil, .dill, .tarragon:
            return "Spices - Savory & Herbal"

        // Herbal / Tea-Like
        case .blackTea, .earlGrey,
             .greenTea, .jasmineGreenTea,
             .oolong, .rooibos,
             .chamomileTea,
             .mintTea, .spearmint, .peppermint,
             .lemongrass, .lemonVerbena,
             .herbalInfusion, .driedHerbs:
            return "Herbal / Tea-Like"

        // Fermented / Alcoholic
        case .redWine, .whiteWine,
             .portWine, .sherry,
             .brandy, .cognac,
             .rum, .spicedRum,
             .whiskey, .bourbon,
             .liqueur, .amaretto, .kirsch,
             .cider, .hardCider,
             .beer, .stout,
             .fermentedFruit, .overripeFruit:
            return "Fermented / Alcoholic"

        // Vegetal / Savory
        case .tomato, .sunDriedTomato,
             .bellPepper, .greenBellPepper, .redBellPepper,
             .jalapeno, .greenChili,
             .cookedVegetables,
             .spinach, .kale, .cabbage, .beet, .carrot, .celery, .cucumber, .zucchini,
             .olive, .greenOlive, .blackOlive:
            return "Vegetal / Savory"

        // Fresh / Green
        case .freshCutGrass,
             .greenLeaf,
             .alfalfa,
             .hay, .wetHay,
             .teaLeaf,
             .eucalyptus,
             .pineNeedle,
             .resinous, .sappy:
            return "Fresh / Green"

        // Nutty / Grain / Cereal
        case .roastedBarley,
             .malt, .maltedBarley,
             .toastedGrain,
             .granola, .cereal, .bran,
             .wheatCracker,
             .ryeBread, .wholegrainBread, .sourdough,
             .oatmeal, .porridge:
            return "Nutty / Grain / Cereal"

        // Roasty / Browned / Smoky
        case .lightRoast, .mediumRoast, .darkRoast,
             .toasted, .roasted,
             .roastedPeanut, .roastedAlmond, .roastedHazelnut,
             .charred, .smoky, .campfireSmoke,
             .pipeTobacco, .cigarBox, .tobaccoLeaf,
             .grilled,
             .burntSugar, .singedToast:
            return "Roasty / Browned / Smoky"

        // Earthy / Mineral
        case .earth, .dampEarth, .pottingSoil,
             .forestFloor, .leafLitter,
             .mushroom, .driedMushroom, .truffle,
             .clay, .chalk,
             .stone, .flint,
             .mineral,
             .graphite:
            return "Earthy / Mineral"

        // Dairy / Lactonic
        case .milk,
             .sweetCream, .heavyCream,
             .condensedMilk, .evaporatedMilk,
             .butter, .brownedButter,
             .yogurt, .greekYogurt,
             .sourCream, .buttermilk:
            return "Dairy / Lactonic"

        // Dried Fruit & Candied
        case .goldenRaisin, .sultana,
             .driedApple, .driedMango,
             .candiedOrangePeel, .candiedLemonPeel,
             .mixedPeel,
             .fruitLeather:
            return "Dried Fruit & Candied"

        // Mouthfeel / Texture
        case .thin,
             .lightBodied, .mediumBodied, .fullBodied,
             .heavyMouthfeel,
             .creamyMouthfeel,
             .silky, .velvety,
             .syrupy, .oily, .juicy,
             .teaLike,
             .roundMouthfeel,
             .coating:
            return "Mouthfeel / Texture"

        // Acidity & Overall Impressions
        case .brightAcidity, .sparklingAcidity,
             .lively, .crisp, .tart, .tangy,
             .mellowAcidity, .softAcidity,
             .balanced,
             .roundProfile,
             .complex, .simpleProfile,
             .clean, .transparent,
             .structured,
             .elegant, .refined,
             .bold, .intense, .delicate:
            return "Acidity & Overall Impressions"
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
    
    
    var displayName: String {
        rawValue
            .replacingOccurrences(
                of: "([a-z])([A-Z])",
                with: "$1 $2",
                options: .regularExpression,
                range: rawValue.startIndex..<rawValue.endIndex
            )
            .capitalized
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
            tastingNotes: [.caramel, .guava, .aniseSeed],
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
        tastingNotes: [.caramel, .milkChocolate, .vanilla],
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
                    tastingNotes: [.caramel, .milkChocolate, .vanilla],
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
                    tastingNotes: [.milkChocolate, .hazelnut, .almond],
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
                    tastingNotes: [.smoky, .acaciaBlossom, .darkChocolate],
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
