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
    
    var selectedCoffee: Coffee? {
        coffeeViewModel.coffees.first { $0.id == selectedCoffeeId }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $recipeName)
                    TextField("Grams In", text: $gramsIn)
                        .keyboardType(.decimalPad)
                    TextField("ML Out", text: $mlOut)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Information")
                } footer: {
                    Text("Please enter all the information above.")
                }
                .headerProminence(.increased)
                
                Section("Coffee") {
                    Button(action: {
                        showCoffeePicker.toggle()
                    }) {
                        HStack {
                            if let coffee = selectedCoffee {
                                CoffeeChoice(coffee: coffee)
                            } else {
                                Text("Select Coffee")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if showCoffeePicker {
                        ForEach(coffeeViewModel.coffees) { coffee in
                            Button(action: {
                                selectedCoffeeId = coffee.id
                                showCoffeePicker = false
                            }) {
                                CoffeeChoice(coffee: coffee)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
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

