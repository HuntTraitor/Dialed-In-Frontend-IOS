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
    @Binding var refreshData: Bool
    @State private var coffeeImageSelection: PhotosPickerItem?
    @State private var coffeeImageObject: UIImage?
    @State private var coffeeImageData: Data?
    @State private var isUploading: Bool = false

    // Local state variables for temporary values
    @State private var tempName: String
    @State private var tempRegion: String
    @State private var tempProcess: String
    @State private var tempDescription: String

    // Initializer to set initial values for local state variables
    init(coffee: Binding<Coffee>, refreshData: Binding<Bool>, viewModel: CoffeeViewModel) {
        self._coffee = coffee
        self.viewModel = viewModel
        self._refreshData = refreshData
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
                                            if let resizedData = loadedImage.compressTo(maxSizeInMB: 1) {
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
                                isUploading = true
                                defer { isUploading = false }
                                do {
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
                                    try await viewModel.updateCoffee(input: coffeeInput, token: authViewModel.token ?? "")
                                    
//                                    coffee.name = updatedCoffee.name
//                                    coffee.region = updatedCoffee.region
//                                    coffee.process = updatedCoffee.process
//                                    coffee.description = updatedCoffee.description
//                                    coffee.img = updatedCoffee.img
                                    
                                    refreshData.toggle()
                                    presentationMode.wrappedValue.dismiss()
                                } catch {
                                    print("❌ Failed to upload coffee: \(error)")
                                }
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
            if isUploading {
                LoadingCircle()
            }
        }
    }
}

//#Preview {
//    struct PreviewWrapper: View {
//        @State private var refreshData: Bool = false
//        @State private var sampleCoffee = Coffee(
//            id: 1,
//            name: "Ethiopian Yirgacheffe",
//            region: "Yirgacheffe, Ethiopia",
//            process: "Washed",
//            description: "Bright and floral with notes of citrus and jasmine",
//            img: nil
//        )
//        
//        var body: some View {
//            let keyChainManager = KeychainManager()
//            
//            EditCoffeeView(
//                coffee: $sampleCoffee,
//                refreshData: $refreshData,
//                viewModel: CoffeeViewModel()
//            )
//            .environmentObject(keyChainManager)
//        }
//    }
//
//    return PreviewWrapper()
//}

