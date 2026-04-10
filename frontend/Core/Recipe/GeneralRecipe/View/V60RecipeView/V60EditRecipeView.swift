//
//  V60EditRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI

struct V60EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var recipe: BaseRecipe<V60Info>
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: RecipeViewModel
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var grinderViewModel: GrinderViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var tempRecipeName: String = ""
    @State private var tempGramsIn: String = ""
    @State private var tempMlOut: String = ""
    @State private var tempGrindSize: String = ""
    @State private var tempPhases: [V60Phase] = []
    
    @State private var selectedCoffeeId: Int?
    @State private var selectedGrinderId: Int?
    @State private var showCoffeePicker = false
    @State private var showGrinderPicker = false
    @State private var searchTerm: String = ""
    @State private var grinderSearchTerm: String = ""
    @State private var isShowingCreateCoffeeView = false
    @State private var isShowingCreateGrinderView = false
    @State private var validationError: String? = nil
    @State private var waterTemp: String = ""
    @State private var isCelsius: Bool = false

    var tempUnit: String { isCelsius ? "°C" : "°F" }
    
    init(recipe: Binding<BaseRecipe<V60Info>>) {
        let waterTemperatureFormValue = recipe.wrappedValue.info.waterTemperatureFormValue
        self._recipe = recipe
        self._tempRecipeName = State(initialValue: recipe.wrappedValue.info.name)
        self._tempGramsIn = State(initialValue: String(recipe.wrappedValue.info.gramsIn))
        self._tempMlOut = State(initialValue: String(recipe.wrappedValue.info.mlOut))
        self._tempGrindSize = State(initialValue: recipe.wrappedValue.info.grindSize ?? "")
        self._tempPhases = State(initialValue: recipe.wrappedValue.info.phases)
        self._selectedCoffeeId = State(initialValue: recipe.wrappedValue.coffee?.id)
        self._selectedGrinderId = State(initialValue: recipe.wrappedValue.grinder?.id)
        self._waterTemp = State(initialValue: waterTemperatureFormValue.temperature)
        self._isCelsius = State(initialValue: waterTemperatureFormValue.isCelsius)
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

                    TextField("Grind Size", text: $tempGrindSize)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                }
                
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
                
                Section("Pours") {
                    if !tempPhases.isEmpty {
                        ForEach(tempPhases.indices, id: \.self) { index in
                            AddV60Phase(
                                phaseNum: .constant(index + 1),
                                phase: $tempPhases[index]
                            )
                        }
                        .onDelete { indexSet in
                            tempPhases.remove(atOffsets: indexSet)
                        }
                    }
                    Button {
                        let newPhase = V60Phase(time: 0, amount: 0)
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
                    await grinderViewModel.fetchGrinders(withToken: authViewModel.token ?? "")
                }
            }
            .sheet(isPresented: $isShowingCreateCoffeeView) {
                CreateCoffeeView()
            }
            .sheet(isPresented: $isShowingCreateGrinderView) {
                NavigationStack { CreateGrinderView() }
            }
            .navigationTitle("Edit V60 Recipe")
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

        guard !waterTemp.isEmpty else {
            return "Water Temperature must be provided."
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
                let mlOutInt = Int(tempMlOut)
            else {
                self.validationError = "Invalid input format."
                return
            }
            
            let unit = isCelsius ? "°C" : "°F"
            let waterTempString = waterTemp.isEmpty ? "" : "\(waterTemp)\(unit)"
            let trimmedGrindSize = tempGrindSize.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let recipeInfo = V60Info(
                name: tempRecipeName,
                gramsIn: gramsInInt,
                mlOut: mlOutInt,
                waterTemp: waterTempString,
                grindSize: trimmedGrindSize.isEmpty ? nil : trimmedGrindSize,
                phases: tempPhases
            )
            
            let newRecipe = BaseRecipeInput<V60Info>(
                methodId: 1,
                coffeeId: selectedCoffeeId,
                grinderId: selectedGrinderId,
                info: recipeInfo
            )
            
            guard let updatedRecipe = await viewModel.editRecipe(
                withToken: authViewModel.token ?? "",
                recipe: newRecipe,
                recipeId: recipe.id
            ) else {
                print("❌ Update failed: no recipe returned")
                return
            }

            if case .v60Recipe(let v60Recipe) = updatedRecipe {
                recipe = v60Recipe
            } else {
                print("❌ Returned recipe was not a SwitchRecipe")
            }
            
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        V60EditRecipeView(recipe: .constant(BaseRecipe<V60Info>.MOCK_V60_RECIPE))
    }
}
