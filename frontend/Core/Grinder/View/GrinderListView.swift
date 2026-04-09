//
//  GrinderListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 4/3/26.
//

import SwiftUI

public struct GrinderListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: GrinderViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var searchTerm: String = ""
    @State private var isShowingCreateGrinderView = false
    @State private var hasAppeared: Bool = false

    @State private var showDeleteAlert: Bool = false
    @State private var grinderToDelete: Grinder? = nil

    @State private var selectedGrinderIdForEdit: Int? = nil

    private var filteredIndices: [Int] {
        viewModel.grinders.indices.filter { idx in
            let grinder = viewModel.grinders[idx]
            return searchTerm.isEmpty || grinder.name.localizedCaseInsensitiveContains(searchTerm)
        }
    }

    private func bindingForGrinder(id: Int) -> Binding<Grinder>? {
        guard let index = viewModel.grinders.firstIndex(where: { $0.id == id }) else { return nil }
        return $viewModel.grinders[index]
    }

    public init() {}

    public var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Header
                HStack {
                    Text("Grinders")
                        .font(.title)
                        .italic()
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .padding(.leading, 30)

                    Spacer()

                    Button {
                        isShowingCreateGrinderView = true
                    } label: {
                        Label("Add New Grinder", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                    .padding(.top, 40)
                    .italic()
                    .sheet(isPresented: $isShowingCreateGrinderView) {
                        NavigationStack {
                            CreateGrinderView()
                        }
                    }
                }

                VStack {
                    SearchBar(text: $searchTerm, placeholder: "Search Grinders")
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)

                    ScrollView {
                        VStack {
                            if let errorMessage = viewModel.errorMessage {
                                FetchErrorMessageScreen(errorMessage: errorMessage)
                                    .scaleEffect(0.9)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 20)
                                    .frame(maxWidth: .infinity)
                            } else if viewModel.grinders.isEmpty {
                                NoResultsFound(itemName: "grinder", systemImage: "gearshape")
                                    .scaleEffect(0.8)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity)
                            } else if filteredIndices.isEmpty && !searchTerm.isEmpty {
                                NoSearchResultsFound(itemName: "grinder")
                                    .scaleEffect(0.8)
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity)
                            } else {
                                ForEach(filteredIndices, id: \.self) { index in
                                    let grinderBinding = $viewModel.grinders[index]
                                    GrinderCard(
                                        grinder: grinderBinding.wrappedValue,
                                        onEdit: {
                                            selectedGrinderIdForEdit = grinderBinding.wrappedValue.id
                                        },
                                        onDelete: {
                                            grinderToDelete = grinderBinding.wrappedValue
                                            showDeleteAlert = true
                                        }
                                    )
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                }
                            }

                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .refreshable {
                        await Task {
                            await viewModel.fetchGrinders(withToken: authViewModel.token ?? "")
                        }.value
                    }
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .task {
                if !hasAppeared {
                    await viewModel.fetchGrinders(withToken: authViewModel.token ?? "")
                    hasAppeared = true
                }
            }

            if viewModel.isLoading {
                LoadingCircle()
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedGrinderIdForEdit != nil },
            set: { if !$0 { selectedGrinderIdForEdit = nil } }
        )) {
            if let id = selectedGrinderIdForEdit, let binding = bindingForGrinder(id: id) {
                NavigationStack {
                    EditGrinderView(grinder: binding)
                }
            }
        }
        .alert("Are you sure you want to delete this grinder?", isPresented: $showDeleteAlert, presenting: grinderToDelete) { grinder in
            Button("Yes", role: .destructive) {
                Task {
                    await viewModel.deleteGrinder(grinderId: grinder.id, token: authViewModel.token ?? "")
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            GrinderListView()
        }
    }
}

