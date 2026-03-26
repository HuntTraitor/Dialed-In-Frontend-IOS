//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CoffeeViewModel
    @State private var searchTerm = ""
    @State private var isShowingCreateCoffeeView = false
    @State private var isShowingFilterView = false
    @State private var hasAppeared: Bool = false
    @State private var isMinimized: Bool = false
    @State private var filter = CoffeeFilter()

    private let testingID = UIIdentifiers.CoffeeScreen.self

    var filteredCoffees: [Coffee] {
        let filtered = filter.apply(to: viewModel.coffees)
        guard !searchTerm.isEmpty else { return filtered }
        return filtered.filter { coffee in
            let info = coffee.info
            let term = searchTerm.lowercased()
            return info.name.localizedCaseInsensitiveContains(term)
                || (info.roaster?.localizedCaseInsensitiveContains(term) ?? false)
                || (info.variety?.localizedCaseInsensitiveContains(term) ?? false)
                || (info.region?.localizedCaseInsensitiveContains(term) ?? false)
                || (info.process?.localizedCaseInsensitiveContains(term) ?? false)
                || (info.roastLevel?.displayName.localizedCaseInsensitiveContains(term) ?? false)
                || (info.originType?.displayName.localizedCaseInsensitiveContains(term) ?? false)
                || (info.tastingNotes?.contains {
                    $0.displayName.localizedCaseInsensitiveContains(term)
                } ?? false)
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Header
                HStack {
                    Text("Coffees")
                        .font(.title)
                        .italic()
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .padding(.leading, 30)
                        .accessibilityIdentifier(testingID.coffeesTitle)

                    Spacer()

                    // Filter button with active badge
                    Button {
                        isShowingFilterView = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 20))
                            if filter.isActive {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 4, y: -4)
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingFilterView) {
                        CoffeeFilterView(filter: $filter)
                    }
                    .padding(.top, 40)

                    Button {
                        isShowingCreateCoffeeView = true
                    } label: {
                        Label("Add New Coffee", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                    .sheet(isPresented: $isShowingCreateCoffeeView) {
                        CreateCoffeeView()
                    }
                    .padding(.top, 40)
                }

                VStack {
                    HStack {
                        SearchBar(text: $searchTerm, placeholder: "Search Coffees")
                            .padding(.horizontal, 10)
                        Button(action: {
                            isMinimized.toggle()
                        }) {
                            Image(systemName: isMinimized ? "chevron.up" : "chevron.down")
                        }
                    }
                    .padding(.bottom, 5)

                    ScrollView {
                        Group {
                            if let errorMessage = viewModel.errorMessage {
                                FetchErrorMessageScreen(errorMessage: errorMessage)
                                    .scaleEffect(0.8)
                            } else if viewModel.coffees.isEmpty {
                                NoResultsFound(
                                    itemName: "coffee",
                                    systemImage: "cup.and.heat.waves"
                                )
                                .scaleEffect(0.8)
                            } else if filteredCoffees.isEmpty {
                                NoSearchResultsFound(itemName: "coffee")
                                    .scaleEffect(0.8)
                            } else {
                                ForEach(filteredCoffees, id: \.self) { coffee in
                                    VStack {
                                        CoffeeRow(coffee: coffee, isMinimized: $isMinimized)
                                    }
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.01), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .refreshable {
                        await viewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .task {
                if !hasAppeared && viewModel.coffees.isEmpty {
                    await viewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                    hasAppeared = true
                }
            }

            if viewModel.isLoading {
                LoadingCircle()
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            CoffeeView()
        }
    }
}
