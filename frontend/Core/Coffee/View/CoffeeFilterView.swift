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

    var onApply: () -> Void = {}

    @State private var isShowingTastingNoteDialog = false

    private let optionColumns = [
        GridItem(.adaptive(minimum: 118), spacing: 10, alignment: .leading)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    textSection
                    roastSection
                    tasteSection
                    costSection
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Filter Coffees")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { resetButton }
                ToolbarItem(placement: .confirmationAction) { applyButton }
            }
        }
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General")
                .font(.subheadline)
                .foregroundColor(Color("background"))

            LabeledTextField(label: "Name", text: $filter.name, placeholder: "Search names")
            Divider()
            LabeledTextField(label: "Roaster", text: $filter.roaster, placeholder: "Search roasters")
            Divider()
            LabeledTextField(label: "Region", text: $filter.region, placeholder: "Search regions")
            Divider()
            LabeledTextField(label: "Process", text: $filter.process, placeholder: "Search processes")
            Divider()
            LabeledTextField(label: "Variety", text: $filter.variety, placeholder: "Search varieties")
        }
        .filterSectionCard()
    }

    private var roastSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Roast")
                .font(.subheadline)
                .foregroundColor(Color("background"))

            optionGroup("Origin Type") {
                LazyVGrid(columns: optionColumns, alignment: .leading, spacing: 10) {
                    ForEach(OriginType.predefinedOptions.filter { $0 != .unknown }, id: \.self) { originType in
                        FilterOptionButton(
                            label: originType.displayName,
                            isSelected: filter.originTypes.contains(originType)
                        ) {
                            filter.originTypes.toggle(originType)
                        }
                    }
                }
            }

            Divider()

            optionGroup("Roast Level") {
                LazyVGrid(columns: optionColumns, alignment: .leading, spacing: 10) {
                    ForEach(RoastLevel.predefinedOptions.filter { $0 != .unknown }, id: \.self) { roastLevel in
                        FilterOptionButton(
                            label: roastLevel.displayName,
                            isSelected: filter.roastLevels.contains(roastLevel)
                        ) {
                            filter.roastLevels.toggle(roastLevel)
                        }
                    }
                }
            }

            Divider()

            optionGroup("Decaf") {
                LazyVGrid(columns: optionColumns, alignment: .leading, spacing: 10) {
                    FilterOptionButton(label: "True", isSelected: filter.decaf == true) {
                        filter.decaf = filter.decaf == true ? nil : true
                    }
                    FilterOptionButton(label: "False", isSelected: filter.decaf == false) {
                        filter.decaf = filter.decaf == false ? nil : false
                    }
                }
            }
        }
        .filterSectionCard()
    }

    private var tasteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Taste")
                .font(.subheadline)
                .foregroundColor(Color("background"))

            optionGroup("Rating") {
                LazyVGrid(columns: optionColumns, alignment: .leading, spacing: 10) {
                    ForEach([Rating.one, .two, .three, .four, .five], id: \.rawValue) { rating in
                        RatingFilterButton(
                            rating: rating,
                            isSelected: filter.ratings.contains(rating)
                        ) {
                            filter.ratings.toggle(rating)
                        }
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("Tasting Notes")
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 10) {
                    if !filter.tastingNotes.isEmpty {
                        TastingNotesView(notes: filter.tastingNotes)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        isShowingTastingNoteDialog = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text(filter.tastingNotes.isEmpty ? "Add Notes" : "Edit Notes")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color("background"))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $isShowingTastingNoteDialog) {
                        NavigationView {
                            TastingNotesDialog(selectedTastingNotes: $filter.tastingNotes)
                                .toolbar {
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Close") {
                                            isShowingTastingNoteDialog = false
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
        .filterSectionCard()
    }

    private var costSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cost")
                .font(.subheadline)
                .foregroundColor(Color("background"))

            HStack {
                Text("Min")
                    .foregroundColor(.gray)
                Spacer()
                TextField("$0.00", value: $filter.minCost, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
            }
            Divider()
            HStack {
                Text("Max")
                    .foregroundColor(.gray)
                Spacer()
                TextField("Any", value: $filter.maxCost, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
            }
        }
        .filterSectionCard()
    }

    private func optionGroup<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var resetButton: some View {
        Button("Reset") {
            filter = CoffeeFilter()
        }
        .foregroundColor(.red)
    }

    private var applyButton: some View {
        Button("Apply") {
            onApply()
            dismiss()
        }
    }
}

private struct FilterOptionButton: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity, minHeight: 36, alignment: .center)
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 10)
            .background(isSelected ? Color("background") : Color.gray.opacity(0.18))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

private struct RatingFilterButton: View {
    let rating: Rating
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Text("\(rating.rawValue)")
                    .font(.subheadline)
                    .bold()
                Image(systemName: "star.fill")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, minHeight: 36, alignment: .center)
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 10)
            .background(isSelected ? Color("background") : Color.gray.opacity(0.18))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

private extension View {
    func filterSectionCard() -> some View {
        self
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
    }
}

private extension Set {
    mutating func toggle(_ element: Element) {
        if contains(element) { remove(element) } else { insert(element) }
    }
}

#Preview {
    @Previewable @State var filter = CoffeeFilter()
    CoffeeFilterView(filter: $filter)
}
