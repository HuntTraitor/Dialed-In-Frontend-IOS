//
//  CreateRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/22/25.
//

import SwiftUI

struct CreateSwitchRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: RecipeViewModel
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @State private var recipeName: String = ""
    @State private var gramsIn: String = ""
    @State private var mlOut: String = ""
    @State private var selectedCoffeeId: Int?
    @State private var showCoffeePicker = false
    @State private var searchTerm: String = ""
    @State private var isShowingCreateCoffeeView = false
    @State private var phases: [SwitchRecipeInput.RecipeInfo.Phase] = []
    @State private var validationError: String? = nil
    
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
                        await coffeeViewModel.fetchCoffees(withToken: authViewModel.token ?? "")
                    }
                }
                .sheet(isPresented: $isShowingCreateCoffeeView) {
                    CreateCoffeeView()
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
            
            await viewModel.postRecipe(withToken: authViewModel.token ?? "", recipe: newRecipe)
            
            if viewModel.errorMessage == nil {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        CreateSwitchRecipeView()
    }
}

