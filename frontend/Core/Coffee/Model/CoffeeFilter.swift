//
//  CoffeeFilter.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import Foundation

struct CoffeeFilter {
    var roastLevels: Set<RoastLevel> = []
    var originTypes: Set<OriginType> = []
    var ratings: Set<Rating> = []
    var decafOnly: Bool = false
    var minCost: Double? = nil
    var maxCost: Double? = nil

    var isActive: Bool {
        !roastLevels.isEmpty ||
        !originTypes.isEmpty ||
        !ratings.isEmpty ||
        decafOnly ||
        minCost != nil ||
        maxCost != nil
    }

    func apply(to coffees: [Coffee]) -> [Coffee] {
        coffees.filter { coffee in
            let info = coffee.info

            if decafOnly && !info.decaf { return false }

            if !roastLevels.isEmpty {
                guard let rl = info.roastLevel, roastLevels.contains(rl) else { return false }
            }

            if !originTypes.isEmpty {
                guard let ot = info.originType, originTypes.contains(ot) else { return false }
            }

            if !ratings.isEmpty {
                guard let r = info.rating, ratings.contains(r) else { return false }
            }

            if let min = minCost {
                guard let cost = info.cost, cost >= min else { return false }
            }

            if let max = maxCost {
                guard let cost = info.cost, cost <= max else { return false }
            }

            return true
        }
    }
}
