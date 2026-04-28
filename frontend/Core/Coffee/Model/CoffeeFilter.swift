//
//  CoffeeFilter.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import Foundation

struct CoffeeFilter {
    var name: String = ""
    var roaster: String = ""
    var region: String = ""
    var process: String = ""
    var variety: String = ""
    var roastLevels: Set<RoastLevel> = []
    var originTypes: Set<OriginType> = []
    var ratings: Set<Rating> = []
    var tastingNotes: [TastingNote] = []
    var decaf: Bool? = nil
    var minCost: Double? = nil
    var maxCost: Double? = nil

    var isActive: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !roaster.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !region.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !process.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !variety.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !roastLevels.isEmpty ||
        !originTypes.isEmpty ||
        !ratings.isEmpty ||
        !tastingNotes.isEmpty ||
        decaf != nil ||
        minCost != nil ||
        maxCost != nil
    }

    func apply(to coffees: [Coffee]) -> [Coffee] {
        coffees.filter { coffee in
            let info = coffee.info

            if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !info.name.localizedCaseInsensitiveContains(name) { return false }

            if !roaster.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !(info.roaster ?? "").localizedCaseInsensitiveContains(roaster) { return false }

            if !region.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !(info.region ?? "").localizedCaseInsensitiveContains(region) { return false }

            if !process.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !(info.process ?? "").localizedCaseInsensitiveContains(process) { return false }

            if !variety.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !(info.variety ?? "").localizedCaseInsensitiveContains(variety) { return false }

            if let decaf, info.decaf != decaf { return false }

            if !roastLevels.isEmpty {
                guard let rl = info.roastLevel, roastLevels.contains(rl) else { return false }
            }

            if !originTypes.isEmpty {
                guard let ot = info.originType, originTypes.contains(ot) else { return false }
            }

            if !ratings.isEmpty {
                guard let r = info.rating, ratings.contains(r) else { return false }
            }

            if !tastingNotes.isEmpty {
                guard let coffeeNotes = info.tastingNotes else { return false }
                guard tastingNotes.allSatisfy({ coffeeNotes.contains($0) }) else { return false }
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
