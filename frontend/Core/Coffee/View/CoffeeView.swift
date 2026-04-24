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
    @State private var hasAppeared: Bool = false
    @State private var isMinimized: Bool = false

    private let testingID = UIIdentifiers.CoffeeScreen.self

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
                    }
                    .padding(.bottom, 5)

                    ScrollView {
                        LazyVStack {
                            if let errorMessage = viewModel.errorMessage {
                                FetchErrorMessageScreen(errorMessage: errorMessage)
                                    .scaleEffect(0.8)
                            } else if viewModel.coffees.isEmpty {
                                NoResultsFound(
                                    itemName: "coffee",
                                    systemImage: "cup.and.heat.waves"
                                )
                                .scaleEffect(0.8)
                            } else if viewModel.coffees.isEmpty {
                                NoSearchResultsFound(itemName: "coffee")
                                    .scaleEffect(0.8)
                            } else {
                                ForEach(viewModel.coffees) { coffee in
                                    VStack {
                                        CoffeeRow(coffee: coffee, isMinimized: $isMinimized)
                                    }
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.01), radius: 5, x: 0, y: 2)
                                    .onAppear {
                                        guard viewModel.shouldFetchMore(after: coffee) else { return }

                                        Task {
                                            await viewModel.fetchMore(withToken: authViewModel.token ?? "")
                                        }
                                    }
                                }

                                if viewModel.isLoadingMore {
                                    ProgressView()
                                        .padding(.vertical, 12)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .refreshable {
                        await Task {
                            await viewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                        }.value
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
