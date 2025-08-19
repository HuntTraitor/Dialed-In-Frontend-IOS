//
//  SwitchEditRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/19/25.
//

import SwiftUI

struct SwitchEditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var recipe: SwitchRecipe
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: RecipeViewModel
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var tempRecipeName: String = ""
    @State private var tempGramsIn: String = ""
    @State private var tempMlOut: String = ""
    @State private var tempPhases: [SwitchPhase] = []
    
    @State private var selectedCoffeeId: Int?
    @State private var showCoffeePicker = false
    @State private var searchTerm: String = ""
    @State private var isShowingCreateCoffeeView = false
    @State private var validationError: String? = nil
    
    init(recipe: Binding<SwitchRecipe>) {
        self._recipe = recipe
        self._tempRecipeName = State(initialValue: recipe.wrappedValue.info.name)
        self._tempGramsIn = State(initialValue: String(recipe.wrappedValue.info.gramsIn))
        self._tempMlOut = State(initialValue: String(recipe.wrappedValue.info.mlOut))
        self._tempPhases = State(initialValue: recipe.wrappedValue.info.phases)
        self._selectedCoffeeId = State(initialValue: recipe.wrappedValue.coffee.id)
    }
    
    var isFormValid: Bool {
        return validateRecipeInput() == nil
    }
    
    var selectedCoffee: Coffee? {
        coffeeViewModel.coffees.first { $0.id == selectedCoffeeId }
    }
    
    var filteredCoffees: [Coffee] {
        guard !searchTerm.isEmpty else { return coffeeViewModel.coffees }
        return coffeeViewModel.coffees.filter {$0.info.name.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    TextField("Name", text: $tempRecipeName)
                    TextField("Total Grams In", text: $tempGramsIn)
                        .keyboardType(.decimalPad)
                    TextField("Total ML Out", text: $tempMlOut)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Information")
                } footer: {
                    Text("Please enter all the information above.")
                }
                .headerProminence(.increased)
                
                Section("Coffee") {
                    CoffeePickerView(
                        selectedCoffeeId: $selectedCoffeeId,
                        showCoffeePicker: $showCoffeePicker,
                        isShowingCreateCoffeeView: $isShowingCreateCoffeeView,
                        searchTerm: $searchTerm
                    )
                }
                
                Section("Pours") {
                    if !tempPhases.isEmpty {
                        ForEach(tempPhases.indices, id: \.self) { index in
                            PhaseRowView(
                                phaseNum: .constant(index + 1),
                                phase: $tempPhases[index]
                            )
                        }
                        .onDelete { indexSet in
                            tempPhases.remove(atOffsets: indexSet)
                        }
                    }
                    Button {
                        let newPhase = SwitchPhase(open: true, time: 0, amount: 0)
                        tempPhases.append(newPhase)
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
                    await coffeeViewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                }
            }
            .sheet(isPresented: $isShowingCreateCoffeeView) {
                CreateCoffeeView()
            }
            .navigationTitle("New Switch Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveRecipe()
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
            
            if viewModel.errorMessage != nil {
                CustomDialog(
                    isActive: .constant(true),
                    title: "Error",
                    message: viewModel.errorMessage ?? "An unknown error has occured.",
                    buttonTitle: "Close",
                    action: {viewModel.errorMessage = nil}
                )
            }
            if viewModel.isLoading {
                LoadingCircle()
            }
        }
    }
    private func validateRecipeInput() -> String? {
        guard !tempRecipeName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return "Recipe name must be provided."
        }
        if tempRecipeName.count > 100 {
            return "Recipe name must not be more than 100 characters."
        }
        
        guard let gramsInInt = Int(tempGramsIn) else {
            return "Grams In must be a number."
        }
        guard let mlOutInt = Int(tempMlOut) else {
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
        
        for (index, phase) in tempPhases.enumerated() {
            if phase.time <= 0 {
                return "Phase \(index + 1): Time must be greater than zero."
            }
            if phase.amount < 0 {
                return "Phase \(index + 1): Amount must be zero or more."
            }
        }
        
        return nil
    }

    
    private func saveRecipe() {
        Task {
            if let validationError = validateRecipeInput() {
                self.validationError = validationError
                return
            }
            guard
                let gramsInInt = Int(tempGramsIn),
                let mlOutInt = Int(tempMlOut),
                let coffeeId = selectedCoffeeId
            else {
                self.validationError = "Invalid input format."
                return
            }
            
            let recipeInfo = SwitchRecipeInput.RecipeInfo(
                name: tempRecipeName,
                gramsIn: gramsInInt,
                mlOut: mlOutInt,
                phases: tempPhases
            )
            
            let newRecipe = SwitchRecipeInput(
                methodId: 2,
                coffeeId: coffeeId,
                info: recipeInfo
            )
            
            await viewModel.editRecipe(withToken: authViewModel.token ?? "", recipe: newRecipe, recipeId: recipe.id)
            if viewModel.errorMessage == nil {
                dismiss()
            }
            print("edited switch recipe to....")
        }
    }
}

#Preview {
    PreviewWrapper {
        SwitchEditRecipeView(recipe: .constant(SwitchRecipe.MOCK_SWITCH_RECIPE))
    }
}

