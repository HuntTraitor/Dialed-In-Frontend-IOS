//
//  EditCoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/11/25.
//

import SwiftUI
import PhotosUI

struct EditCoffeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var coffee: Coffee
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var coffeeImageSelection: PhotosPickerItem?
    @State private var coffeeImageObject: UIImage?
    @State private var coffeeImageData: Data?

    // Local state variables for temporary values
    @State private var tempName: String
    @State private var tempRegion: String
    @State private var tempProcess: String
    @State private var tempDescription: String

    // Initializer to set initial values for local state variables
    init(coffee: Binding<Coffee>, viewModel: CoffeeViewModel) {
        self._coffee = coffee
        self.viewModel = viewModel
        self._tempName = State(initialValue: coffee.wrappedValue.name)
        self._tempRegion = State(initialValue: coffee.wrappedValue.region)
        self._tempProcess = State(initialValue: coffee.wrappedValue.process)
        self._tempDescription = State(initialValue: coffee.wrappedValue.description)
    }
    
    private var isFormValid: Bool {
        return (
            viewModel.isValidName(name: tempName)
            && viewModel.isValidRegion(region: tempRegion)
            && viewModel.isValidProcess(process: tempProcess)
            && viewModel.isValidDescription(description: tempDescription)
        )
    }

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Name", text: $tempName)
                        TextField("Region", text: $tempRegion)
                        TextField("Process", text: $tempProcess)
                    } header: {
                        Text("Information")
                    } footer: {
                        Text("Please enter all information about the coffee below")
                    }
                    .headerProminence(.increased)
                    
                    Section("Coffee Image") {
                        if let coffeeImageObject {
                            VStack {
                                Image(uiImage: coffeeImageObject)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                        PhotosPicker("Pick a coffee image", selection: $coffeeImageSelection)
                        .onChange(of: coffeeImageSelection, initial: false) { oldValue, newValue in
                            Task(priority: .userInitiated) {
                                if let newValue {
                                    if let loadedImageData = try? await newValue.loadTransferable(type: Data.self),
                                       let loadedImage = UIImage(data: loadedImageData)
                                    {
                                        if let resizedData = loadedImage.compressTo(maxSizeInKB: 1000) {
                                            DispatchQueue.main.async {
                                                self.coffeeImageObject = UIImage(data: resizedData)
                                                self.coffeeImageData = resizedData
                                            }
                                        } else {
                                            print("❌ Compression failed")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Section("Coffee Description") {
                        TextField("Description", text: $tempDescription, axis: .vertical)
                    }
                }
                .navigationTitle("Edit Coffee")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            Task {
                                let imageData = coffeeImageData
                                let coffeeInput = CoffeeInput(
                                    id: coffee.id,
                                    name: tempName,
                                    region: tempRegion,
                                    process: tempProcess,
                                    description: tempDescription,
                                    img: imageData
                                )
                                
                                print("📤 Updating CoffeeInput with compressed image...")
                                let updatedCoffee = await viewModel.updateCoffee(input: coffeeInput, token: authViewModel.token ?? "")
                                
                                guard let updatedCoffee else {
                                    print("❌ Update failed: no coffee returned")
                                    return
                                }
                                
                                coffee.name = updatedCoffee.name
                                coffee.region = updatedCoffee.region
                                coffee.process = updatedCoffee.process
                                coffee.description = updatedCoffee.description
                                coffee.img = updatedCoffee.img
                                
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .disabled(!isFormValid)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel", role: .cancel) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
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
}

#Preview {
    struct PreviewWrapper: View {
        @State private var refreshData: Bool = false
        @State private var sampleCoffee = Coffee(
            id: 1,
            name: "Ethiopian Yirgacheffe",
            region: "Yirgacheffe, Ethiopia",
            process: "Washed",
            description: "Bright and floral with notes of citrus and jasmine",
            img: nil
        )
        
        var body: some View {
            let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
            let viewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))
            
            EditCoffeeView(
                coffee: $sampleCoffee,
                viewModel: viewModel
            )
            .environmentObject(authViewModel)
        }
    }

    return PreviewWrapper()
}

