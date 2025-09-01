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
                    Text("Select Coffee")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: showCoffeePicker ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
        }


        if showCoffeePicker {
            SearchBar(text: $searchTerm, placeholder: "Search Coffees")

            if !filteredCoffees.isEmpty {
                ScrollView {
                    VStack(spacing: 0) {
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
                                    .frame(height: 0.5)
                                    .background(Color.gray.opacity(0.3))
                            }
                        }
                    }
                }
                .frame(maxHeight: 4 * 48)
            }

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

//#Preview {
//    struct PreviewWrapper: View {
//        @StateObject var viewModel = CoffeeViewModel()
//        @State var selectedCoffeeId: Int? = nil
//        @State var showCoffeePicker = false
//        @State var isShowingCreateCoffeeView = false
//        @State var searchTerm = ""
//
//        var body: some View {
//            CoffeePickerView(
//                viewModel: viewModel,
//                selectedCoffeeId: $selectedCoffeeId,
//                showCoffeePicker: $showCoffeePicker,
//                isShowingCreateCoffeeView: $isShowingCreateCoffeeView,
//                searchTerm: $searchTerm
//            )
//            .frame(width: 300)
//            .onAppear {
//                viewModel.coffees = Coffee.MOCK_COFFEES
//            }
//        }
//    }
//
//    return PreviewWrapper()
//}



