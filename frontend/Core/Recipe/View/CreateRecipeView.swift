//
//  CreateRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/22/25.
//

import SwiftUI

struct CreateRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var keychainManager: KeychainManager
    @ObservedObject var viewModel: RecipeViewModel
    @ObservedObject var coffeeViewModel: CoffeeViewModel
    @State private var recipeName: String = ""
    @State private var gramsIn: String = ""
    @State private var mlOut: String = ""
    @State private var selectedCoffeeId: Int?
    @State private var showCoffeePicker = false
    @State private var searchTerm: String = ""
    @State private var isShowingCreateCoffeeView = false
    @State public var refreshData: Bool = false
    @State private var phases: [SwitchRecipe.RecipeInfo.Phase] = []
    
    var selectedCoffee: Coffee? {
        coffeeViewModel.coffees.first { $0.id == selectedCoffeeId }
    }
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return coffeeViewModel.coffees }
        return coffeeViewModel.coffees.filter {$0.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $recipeName)
                    TextField("Total Grams In", text: $gramsIn)
                        .keyboardType(.decimalPad)
                    TextField("Total ML Out", text: $mlOut)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Information")
                } footer: {
                    Text("Please enter all the information above.")
                }
                .headerProminence(.increased)
                
                Section("Coffee") {
                    CoffeePickerView(
                        viewModel: coffeeViewModel,
                        selectedCoffeeId: $selectedCoffeeId,
                        showCoffeePicker: $showCoffeePicker,
                        isShowingCreateCoffeeView: $isShowingCreateCoffeeView,
                        searchTerm: $searchTerm
                    )
                }
                
                Section("Pours") {
                    if !phases.isEmpty {
                        ForEach(phases.indices, id: \.self) { index in
                            PhaseRowView(
                                phaseNum: .constant(index + 1),
                                phase: $phases[index]
                            )
                        }
                        .onDelete { indexSet in
                            phases.remove(atOffsets: indexSet)
                        }
                    }
                    Button {
                        let newPhase = SwitchRecipe.RecipeInfo.Phase(open: true, time: 0, amount: 0)
                        phases.append(newPhase)
                    } label: {
                        Label("Add Pour...", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateCoffeeView) {
                CreateCoffeeView(viewModel: coffeeViewModel, refreshData: $refreshData)
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(recipeName.isEmpty || gramsIn.isEmpty || mlOut.isEmpty || selectedCoffeeId == nil)
                }
            }
        }
    }
    
    private func saveRecipe() {
        // Your save logic here
    }
}

#Preview {
    let keychainManager = KeychainManager()
    let coffeeViewModel = CoffeeViewModel()
    coffeeViewModel.coffees = Coffee.MOCK_COFFEES
    
    return CreateRecipeView(viewModel: RecipeViewModel(), coffeeViewModel: coffeeViewModel)
        .environmentObject(keychainManager)
}

