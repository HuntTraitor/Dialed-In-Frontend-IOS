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
    var region: String
    var process: String
    var description: String
    var img: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, region, process, description, img
    }
}

// ENUMS ------------------------------------------------------------------------------------------------------------
//enum FetchCoffeesResult {
//    case coffees([Coffee])
//    case error([String: Any])
//}
//
//enum PostCoffeeResult {
//    case coffee(Coffee)
//    case error([String: Any])
//}
//
//enum DeleteCoffeeResult {
//    case deleted(Bool)
//    case error([String: Any])
//}
//
//enum UpdateCoffeeResult {
//    case coffee(Coffee)
//    case error([String: Any])
//}

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
    let region: String
    let process: String
    let description: String
    let img: Data?

    func toMultiPartData(boundary: String) -> Data {
        var data = Data()

        let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8)!

        // Append name
        data.append(boundaryPrefix)
        data.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(name)\r\n".data(using: .utf8)!)

        // Append region
        data.append(boundaryPrefix)
        data.append("Content-Disposition: form-data; name=\"region\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(region)\r\n".data(using: .utf8)!)

        // Append process
        data.append(boundaryPrefix)
        data.append("Content-Disposition: form-data; name=\"process\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(process)\r\n".data(using: .utf8)!)

        // Append description
        data.append(boundaryPrefix)
        data.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(description)\r\n".data(using: .utf8)!)

        if img != nil {
            // Append image
            data.append(boundaryPrefix)
            data.append("Content-Disposition: form-data; name=\"img\"; filename=\"coffee.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(img!) // Use the compressed Data directly
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
        region: "Colombia",
        process: "Thermal Shock",
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
    )
    
    static var MOCK_COFFEE_INPUT = CoffeeInput(
        id: nil,
        name: "Milky Cake",
        region: "Colombia",
        process: "Thermal Shock",
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        img: nil
    )
}

extension Coffee {
    static var MOCK_COFFEES = [
        Coffee(
            id: 1,
            name: "Milky Cake",
            region: "Colombia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        Coffee(
            id: 2,
            name: "Milky Cake",
            region: "Colombia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        Coffee(
            id: 3,
            name: "Milky Cake",
            region: "Colombia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        Coffee(
            id: 4,
            name: "Milky Cake",
            region: "Colombia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        Coffee(
            id: 5,
            name: "Milky Cake",
            region: "Colombia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
        Coffee(
            id: 6,
            name: "Milky Cake",
            region: "Colombia",
            process: "Thermal Shock",
            description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
            img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
        ),
    ]
}
