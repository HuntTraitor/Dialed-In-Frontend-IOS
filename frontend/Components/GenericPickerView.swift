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

    var filteredItems: [Item] {
        guard !searchTerm.isEmpty else { return items }
        return items.filter { matchesSearch($0, searchTerm) }
    }

    var selectedItem: Item? {
        items.first { $0.id == selectedItemId }
    }

    var shouldShowNoneOption: Bool {
        searchTerm.isEmpty || "none".localizedCaseInsensitiveContains(searchTerm)
    }

    var body: some View {
        Button(action: {
            withAnimation {
                showPicker.toggle()
            }
        }) {
            HStack {
                if let item = selectedItem {
                    choiceView(item)
                        .frame(height: 35)
                        .padding(.vertical, 1)
                } else {
                    Text("None")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())

        if showPicker {
            SearchBar(text: $searchTerm, placeholder: searchPlaceholder)

            ScrollView {
                VStack(spacing: 0) {
                    if shouldShowNoneOption {
                        Button {
                            selectedItemId = nil
                            showPicker = false
                        } label: {
                            noneChoiceView()
                                .overlay(
                                    HStack {
                                        Spacer()
                                        if selectedItemId == nil {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.accentColor)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                )
                        }
                        .buttonStyle(PlainButtonStyle())

                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }

                    ForEach(filteredItems.indices, id: \.self) { index in
                        Button {
                            selectedItemId = filteredItems[index].id
                            showPicker = false
                        } label: {
                            choiceView(filteredItems[index])
                        }
                        .buttonStyle(PlainButtonStyle())

                        if index != filteredItems.indices.last {
                            Divider()
                                .background(Color.gray.opacity(0.3))
                        }
                    }
                }
            }
            .frame(maxHeight: 4 * 48)

            Button {
                isShowingCreateView = true
            } label: {
                Label(addButtonTitle, systemImage: "plus")
                    .font(.system(size: 15))
                    .bold()
                    .padding(.trailing, 30)
            }
            .italic()
        }
    }
}
