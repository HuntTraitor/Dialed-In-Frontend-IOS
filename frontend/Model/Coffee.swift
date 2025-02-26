//
//  Coffee.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/11/25.
//

import Foundation

struct Coffee: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let region: String
    let process: String
    let description: String
    let img: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case process
        case description
        case img
    }
}

extension Coffee {
    static var MOCK_COFFEE = Coffee(id: 1, name: "Milky Cake", region: "Columbia", process: "Thermal Shock", description: "This is a delicious sweet coffee that has notes of caramel and chocolate.", img: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png")
}
