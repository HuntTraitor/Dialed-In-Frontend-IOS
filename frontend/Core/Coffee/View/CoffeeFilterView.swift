//
//  CoffeeFilterView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import SwiftUI

struct CoffeeFilterView: View {
    @Binding var filter: CoffeeFilter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Roast Level
                Section("Roast Level") {
                    ForEach(RoastLevel.predefinedOptions, id: \.id) { level in
                        FilterToggleRow(
                            label: level.displayName,
                            isOn: filter.roastLevels.contains(level)
                        ) {
                            filter.roastLevels.toggle(level)
                        }
                    }
                }

                // MARK: - Origin Type
                Section("Origin Type") {
                    ForEach(OriginType.predefinedOptions, id: \.id) { origin in
                        FilterToggleRow(
                            label: origin.displayName,
                            isOn: filter.originTypes.contains(origin)
                        ) {
                            filter.originTypes.toggle(origin)
                        }
                    }
                }

                // MARK: - Rating
                Section("Rating") {
                    ForEach(
                        [Rating.one, .two, .three, .four, .five],
                        id: \.rawValue
                    ) { rating in
                        FilterToggleRow(
                            label: String(repeating: "★", count: rating.rawValue),
                            isOn: filter.ratings.contains(rating),
                            labelColor: Color("background")
                        ) {
                            filter.ratings.toggle(rating)
                        }
                    }
                }

                // MARK: - Cost Range
                Section("Cost Range") {
                    HStack {
                        Text("Min")
                            .frame(width: 40, alignment: .leading)
                        TextField(
                            "$0.00",
                            value: $filter.minCost,
                            format: .currency(code: "USD")
                        )
                        .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Max")
                            .frame(width: 40, alignment: .leading)
                        TextField(
                            "Any",
                            value: $filter.maxCost,
                            format: .currency(code: "USD")
                        )
                        .keyboardType(.decimalPad)
                    }
                }

                // MARK: - Other
                Section("Other") {
                    Toggle("Decaf Only", isOn: $filter.decafOnly)
                }
            }
            .navigationTitle("Filter Coffees")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") { filter = CoffeeFilter() }
                        .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Helpers


private struct FilterToggleRow: View {
    let label: String
    let isOn: Bool
    var labelColor: Color = .primary
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(label)
                    .foregroundColor(labelColor)
                Spacer()
                if isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

private extension Set {
    mutating func toggle(_ element: Element) {
        if contains(element) { remove(element) } else { insert(element) }
    }
}
