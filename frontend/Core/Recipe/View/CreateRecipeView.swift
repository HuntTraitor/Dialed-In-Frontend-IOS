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
    @State private var coffeeRefreshData: Bool = false
    @State public var refreshData: Bool = false
    @State private var phases: [SwitchRecipeInput.RecipeInfo.Phase] = []
    @State private var isUploading: Bool = false
    
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
                        let newPhase = SwitchRecipeInput.RecipeInfo.Phase(open: true, time: 0, amount: 0)
                        phases.append(newPhase)
                    } label: {
                        Label("Add Pour...", systemImage: "plus")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.trailing, 30)
                    }
                }
            }
            .onAppear {
                Task {
                    await coffeeViewModel.fetchCoffees(withToken: keychainManager.getToken())
                }
            }
            .onChange(of: coffeeRefreshData) { _, _ in
                Task {
                    await coffeeViewModel.fetchCoffees(withToken: keychainManager.getToken())
                }
            }
            .sheet(isPresented: $isShowingCreateCoffeeView) {
                CreateCoffeeView(viewModel: coffeeViewModel, refreshData: $coffeeRefreshData)
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveRecipe()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(recipeName.isEmpty || gramsIn.isEmpty || mlOut.isEmpty || selectedCoffeeId == nil)
                }
            }
        }
    }
    
    private func saveRecipe() {
        Task {
            isUploading = true
            defer { isUploading = false }
            
            do {
                
                guard
                    let gramsInInt = Int(gramsIn),
                    let mlOutInt = Int(mlOut),
                    let coffeeId = selectedCoffeeId
                else {
                    print("Invalid input")
                    return
                }
                
                let recipeInfo = SwitchRecipeInput.RecipeInfo(
                    name: recipeName,
                    gramsIn: gramsInInt,
                    mlOut: mlOutInt,
                    phases: phases
                )
                
                let newRecipe = SwitchRecipeInput(
                    methodId: 2,
                    coffeeId: coffeeId,
                    info: recipeInfo
                )
                
                
                print("📤 Uploading Recipe...")
                
                try await viewModel.postSwitchRecipe(withToken: keychainManager.getToken(), recipe: newRecipe)
                presentationMode.wrappedValue.dismiss()
                refreshData.toggle()
            } catch {
                print("❌ Failed to upload recipe: \(error)")
            }
        }
    }

}

#Preview {
    let keychainManager = KeychainManager()
    keychainManager.saveToken("LIPIEZJZ74LJVJ5YNWKPWAEYYM")
    let coffeeViewModel = CoffeeViewModel()
    
    return CreateRecipeView(viewModel: RecipeViewModel(), coffeeViewModel: coffeeViewModel)
        .environmentObject(keychainManager)
}

