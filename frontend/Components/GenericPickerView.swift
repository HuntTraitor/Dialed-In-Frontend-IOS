//
//  GenericPickerView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 4/9/26.
//

import SwiftUI

struct GenericPickerView<Item, ChoiceContent: View, NoneContent: View>: View where Item: Identifiable, Item.ID: Hashable {
    let items: [Item]
    @Binding var selectedItemId: Item.ID?
    @Binding var showPicker: Bool
    @Binding var isShowingCreateView: Bool
    @Binding var searchTerm: String

    let searchPlaceholder: String
    let addButtonTitle: String
    let matchesSearch: (Item, String) -> Bool
    let choiceView: (Item) -> ChoiceContent
    let noneChoiceView: () -> NoneContent

    private var filteredItems: [Item] {
        guard !searchTerm.isEmpty else { return items }
        return items.filter { matchesSearch($0, searchTerm) }
    }

    private var selectedItem: Item? {
        items.first { $0.id == selectedItemId }
    }

    private var shouldShowNoneOption: Bool {
        searchTerm.isEmpty || "none".localizedCaseInsensitiveContains(searchTerm)
    }

    private var optionRowCount: Int {
        filteredItems.count + (shouldShowNoneOption ? 1 : 0)
    }

    var body: some View {
        VStack(spacing: 0) {
            pickerButton

            if showPicker {
                Divider()
                    .overlay(Color.gray.opacity(0.25))

            SearchBar(text: $searchTerm, placeholder: searchPlaceholder)
                .padding(.vertical, 6)

                Divider()
                    .overlay(Color.gray.opacity(0.25))

                if optionRowCount > 4 {
                    ScrollView {
                        optionsContent
                    }
                    .frame(maxHeight: 4 * 43)
                } else {
                    optionsContent
                }

                Divider()
                    .overlay(Color.gray.opacity(0.25))

                Button {
                    isShowingCreateView = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .semibold))

                        Text(addButtonTitle)
                            .font(.system(size: 15, weight: .semibold))
                            .italic()

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                    .padding(.horizontal, 4)
                    .foregroundStyle(Color("background"))
                }
                .buttonStyle(.plain)
                .padding(.top, 6)
            }
        }
    }

    private var pickerButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showPicker.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                Group {
                    if let item = selectedItem {
                        choiceView(item)
                    } else {
                        noneChoiceView()
                    }
                }

                Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 42)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var optionsContent: some View {
        VStack(spacing: 0) {
            if shouldShowNoneOption {
                optionButton(isSelected: selectedItemId == nil) {
                    noneChoiceView()
                } action: {
                    selectedItemId = nil
                    showPicker = false
                }

                if !filteredItems.isEmpty {
                    Divider()
                        .overlay(Color.gray.opacity(0.25))
                }
            }

            ForEach(Array(filteredItems.enumerated()), id: \.offset) { index, item in
                optionButton(isSelected: item.id == selectedItemId) {
                    choiceView(item)
                } action: {
                    selectedItemId = item.id
                    showPicker = false
                }

                if index != filteredItems.count - 1 {
                    Divider()
                        .overlay(Color.gray.opacity(0.25))
                }
            }
        }
    }

    private func optionButton<Content: View>(
        isSelected: Bool,
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                content()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 42)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
