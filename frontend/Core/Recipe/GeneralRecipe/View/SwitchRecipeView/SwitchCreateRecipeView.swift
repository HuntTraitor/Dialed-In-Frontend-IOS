//
//  CreateRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/22/25.
//

import SwiftUI

struct SwitchCreateRecipeView: View {
    let existingRecipe: BaseRecipe<SwitchInfo>?
    let onSuccess: (() -> Void)?
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: RecipeViewModel
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var grinderViewModel: GrinderViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var recipeName: String = ""
    @State private var gramsIn: String = ""
    @State private var mlOut: String = ""
    @State private var selectedCoffeeId: Int?
    @State private var selectedGrinderId: Int?
    @State private var showCoffeePicker = false
    @State private var showGrinderPicker = false
    @State private var searchTerm: String = ""
    @State private var grinderSearchTerm: String = ""
    @State private var isShowingCreateCoffeeView = false
    @State private var isShowingCreateGrinderView = false
    @State private var phases: [SwitchPhase] = []
    @State private var validationError: String? = nil
    @State private var waterTemp: String = ""
    @State private var isCelsius: Bool = false
    @State private var grindSize: String = ""

    // Add this computed property:
    var tempUnit: String { isCelsius ? "°C" : "°F" }
    
    @State private var hasPrefilledFromExisting = false

    init(existingRecipe: BaseRecipe<SwitchInfo>? = nil, onSuccess: (() -> Void)? = nil) {
        self.existingRecipe = existingRecipe
        self.onSuccess = onSuccess
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
                
                Section("Water Temperature") {
                    HStack {
                        TextField("Temperature", text: $waterTemp)
                            .keyboardType(.numberPad)
                            .onChange(of: waterTemp) {
                                waterTemp = waterTemp.filter { $0.isNumber }
                            }
                        
                        Divider()
                        
                        Picker("Unit", selection: $isCelsius) {
                            Text("°F").tag(false)
                            Text("°C").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 80)
                    }
                }
                
                Section("Coffee") {
                    GenericPickerView(
                        items: coffeeViewModel.coffees,
                        selectedItemId: $selectedCoffeeId,
                        showPicker: $showCoffeePicker,
                        isShowingCreateView: $isShowingCreateCoffeeView,
                        searchTerm: $searchTerm,
                        searchPlaceholder: "Search Coffees",
                        addButtonTitle: "Add a new coffee...",
                        matchesSearch: { coffee, term in
                            coffee.info.name.localizedCaseInsensitiveContains(term)
                        },
                        choiceView: { coffee in
                            CoffeeChoice(coffee: coffee)
                        },
                        noneChoiceView: {
                            CoffeeChoiceNone()
                        }
                    )
                }
                
                Section("Grinder") {
                    GenericPickerView(
                        items: grinderViewModel.grinders,
                        selectedItemId: $selectedGrinderId,
                        showPicker: $showGrinderPicker,
                        isShowingCreateView: $isShowingCreateGrinderView,
                        searchTerm: $grinderSearchTerm,
                        searchPlaceholder: "Search Grinders",
                        addButtonTitle: "Add a new grinder...",
                        matchesSearch: { grinder, term in
                            grinder.name.localizedCaseInsensitiveContains(term)
                        },
                        choiceView: { grinder in
                            GrinderChoice(grinder: grinder)
                        },
                        noneChoiceView: {
                            GrinderChoiceNone()
                        }
                    )
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }

                    TextField("Grind Size", text: $grindSize)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
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
                        let newPhase = SwitchPhase(open: true, time: 0, amount: 0)
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
                    await grinderViewModel.fetchGrinders(withToken: authViewModel.token ?? "")
                    
                    prefillFromExistingRecipeIfNeeded()
                }
            }
            .sheet(isPresented: $isShowingCreateCoffeeView) {
                CreateCoffeeView()
            }
            .sheet(isPresented: $isShowingCreateGrinderView) {
                NavigationStack { CreateGrinderView() }
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

        guard !waterTemp.isEmpty else {
            return "Water Temperature must be provided."
        }
        
        if phases.count <= 0 {
            return "At least one phase must be provided."
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
                let mlOutInt = Int(mlOut)
            else {
                self.validationError = "Invalid input format."
                return
            }
            
            let unit = isCelsius ? "°C" : "°F"
            let waterTempString = waterTemp.isEmpty ? "" : "\(waterTemp)\(unit)"
            let trimmedGrindSize = grindSize.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let recipeInfo = SwitchInfo(
                name: recipeName,
                gramsIn: gramsInInt,
                mlOut: mlOutInt,
                waterTemp: waterTempString,
                grindSize: trimmedGrindSize.isEmpty ? nil : trimmedGrindSize,
                phases: phases
            )
            
            let newRecipe = BaseRecipeInput<SwitchInfo>(
                methodId: 2,
                coffeeId: selectedCoffeeId,
                grinderId: selectedGrinderId,
                info: recipeInfo
            )
            
            print("📤 Uploading Recipe...")
            
            await viewModel.postRecipe(withToken: authViewModel.token ?? "", recipe: newRecipe)
            
            if viewModel.errorMessage == nil {
                if onSuccess != nil {
                    onSuccess?()
                } else {
                    if !navigationManager.recipesNavigator.isEmpty {
                        navigationManager.recipesNavigator.removeLast()
                    }
                    dismiss()
                }
            }
        }
    }
    
    private func prefillFromExistingRecipeIfNeeded() {
        guard !hasPrefilledFromExisting, let recipe = existingRecipe else { return }

        hasPrefilledFromExisting = true

        recipeName = recipe.info.name
        gramsIn = String(recipe.info.gramsIn)
        mlOut   = String(recipe.info.mlOut)
        phases  = recipe.info.phases
        grindSize = recipe.info.grindSize ?? ""

        let waterTemperatureFormValue = recipe.info.waterTemperatureFormValue
        waterTemp = waterTemperatureFormValue.temperature
        isCelsius = waterTemperatureFormValue.isCelsius

        selectedCoffeeId = recipe.coffee?.id
        selectedGrinderId = recipe.grinder?.id
    }

}

#Preview {
    PreviewWrapper {
        SwitchCreateRecipeView()
    }
}
