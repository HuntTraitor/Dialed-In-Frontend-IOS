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
    @Binding public var refreshData: Bool
    @State private var phases: [SwitchRecipeInput.RecipeInfo.Phase] = []
    @State private var isUploading: Bool = false
    @State private var validationError: String? = nil
    
    var isFormValid: Bool {
        return validateRecipeInput() == nil
    }
    
    var selectedCoffee: Coffee? {
        coffeeViewModel.coffees.first { $0.id == selectedCoffeeId }
    }
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return coffeeViewModel.coffees }
        return coffeeViewModel.coffees.filter {$0.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        ZStack {
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
                        .disabled(!isFormValid)
                    }
                }
                .alert("Validation Error", isPresented: .constant(validationError != nil), actions: {
                    Button("OK", role: .cancel) {
                        validationError = nil
                    }
                }, message: {
                    if let message = validationError {
                        Text(message)
                    }
                })
            }
            if isUploading {
                LoadingCircle()
            }
        }
    }
    
    private func validateRecipeInput() -> String? {
        guard !recipeName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return "Recipe name must be provided."
        }
        if recipeName.count > 100 {
            return "Recipe name must not be more than 100 characters."
        }
        
        guard let gramsInInt = Int(gramsIn) else {
            return "Grams In must be a number."
        }
        guard let mlOutInt = Int(mlOut) else {
            return "ML Out must be a number."
        }
        
        if gramsInInt <= 0 {
            return "Grams In must be greater than zero."
        }
        if gramsInInt >= 10000 {
            return "Grams In must be less than ten thousand."
        }
        if mlOutInt <= 0 {
            return "ML Out must be greater than zero."
        }
        if mlOutInt >= 1000 {
            return "ML Out must be less than a thousand."
        }
        
        for (index, phase) in phases.enumerated() {
            if phase.open {
                return "Phase \(index + 1): Open must be provided."
            }
            if phase.time <= 0 {
                return "Phase \(index + 1): Time must be greater than zero."
            }
            if phase.amount < 0 {
                return "Phase \(index + 1): Amount must be zero or more."
            }
        }
        
        return nil // Validation succcessful
    }

    
    private func saveRecipe() {
        Task {
            isUploading = true
            defer { isUploading = false }
            
            if let validationError = validateRecipeInput() {
                self.validationError = validationError
                return
            }

            do {
                guard
                    let gramsInInt = Int(gramsIn),
                    let mlOutInt = Int(mlOut),
                    let coffeeId = selectedCoffeeId
                else {
                    self.validationError = "Invalid input format."
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
                self.validationError = "❌ Failed to upload recipe: \(error.localizedDescription)"
            }
        }
    }


}

#Preview {
    struct PreviewWrapper: View {
        @State private var refreshData: Bool = false
        var body: some View {
            let keyChainManager = KeychainManager()
            CreateRecipeView(viewModel: RecipeViewModel(), coffeeViewModel: CoffeeViewModel(), refreshData: $refreshData)
                .environmentObject(keyChainManager)
        }
    }
    return PreviewWrapper()
}

