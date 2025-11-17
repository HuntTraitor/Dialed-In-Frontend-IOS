//
//  CoffeePickerView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/23/25.
//

import SwiftUI

struct CoffeePickerView: View {
    @EnvironmentObject var viewModel: CoffeeViewModel
    @Binding var selectedCoffeeId: Int?
    @Binding var showCoffeePicker: Bool
    @Binding var isShowingCreateCoffeeView: Bool
    @Binding var searchTerm: String
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return viewModel.coffees }
        return viewModel.coffees.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var selectedCoffee: Coffee? {
        viewModel.coffees.first { $0.id == selectedCoffeeId }
    }
    
    var shouldShowNoneOption: Bool {
        searchTerm.isEmpty ||
        "none".localizedCaseInsensitiveContains(searchTerm)
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                showCoffeePicker.toggle()
            }
        }) {
            HStack {
                if let coffee = selectedCoffee {
                    CoffeeChoice(coffee: coffee)
                        .frame(height: 35)
                        .padding(.vertical, 1)
                } else {
                    Text("None")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: showCoffeePicker ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
        }


        if showCoffeePicker {
            SearchBar(text: $searchTerm, placeholder: "Search Coffees")

            ScrollView {
                VStack(spacing: 0) {
                    if shouldShowNoneOption {
                        Button {
                            selectedCoffeeId = nil
                            showCoffeePicker = false
                        } label: {
                            CoffeeChoiceNone()
                                .overlay(
                                    HStack {
                                        Spacer()
                                        if selectedCoffeeId == nil {
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

                    ForEach(filteredCoffees.indices, id: \.self) { index in
                        Button {
                            selectedCoffeeId = filteredCoffees[index].id
                            showCoffeePicker = false
                        } label: {
                            CoffeeChoice(coffee: filteredCoffees[index])
                        }
                        .buttonStyle(PlainButtonStyle())

                        if index != filteredCoffees.indices.last {
                            Divider()
                                .background(Color.gray.opacity(0.3))
                        }
                    }
                }
            }
            .frame(maxHeight: 4 * 48)




            Button {
                isShowingCreateCoffeeView = true
            } label: {
                Label("Add a new coffee...", systemImage: "plus")
                    .font(.system(size: 15))
                    .bold()
                    .padding(.trailing, 30)
            }
            .italic()
        }
    }
}



