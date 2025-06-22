//
//  CreateCoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/17/25.
//

import SwiftUI
import PhotosUI

struct CreateCoffeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var keyChainManager: KeychainManager
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var coffeeName: String = ""
    @State private var coffeeRegion: String = ""
    @State private var coffeeProcess: String = ""
    @State private var coffeeDescription: String = ""
    @State private var coffeeImageSelection: PhotosPickerItem?
    @State private var coffeeImageObject: UIImage?
    @State private var coffeeImageData: Data?
    @State private var isUploading: Bool = false
    @Binding public var refreshData: Bool
    
    private var isFormValid: Bool {
        return (
            viewModel.isValidName(name: coffeeName)
            && viewModel.isValidRegion(region: coffeeRegion)
            && viewModel.isValidProcess(process: coffeeProcess)
            && viewModel.isValidDescription(description: coffeeDescription)
        )
    }

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Name", text: $coffeeName)
                        TextField("Region", text: $coffeeRegion)
                        TextField("Process", text: $coffeeProcess)
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
                        TextField("Description", text: $coffeeDescription, axis: .vertical)
                    }
                }
                .navigationTitle("Add Coffee")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            Task {
                                isUploading = true
                                defer { isUploading = false }
                                do {
                                    guard let imageData = coffeeImageData else {
                                        print("❌ No image selected or failed to convert to Data")
                                        return
                                    }
                                    
                                    let coffeeInput = CoffeeInput(
                                        id: nil,
                                        name: coffeeName,
                                        region: coffeeRegion,
                                        process: coffeeProcess,
                                        description: coffeeDescription,
                                        img: imageData
                                    )
                                    
                                    print("📤 Uploading CoffeeInput with compressed image...")
                                    try await viewModel.postCoffee(input: coffeeInput, token: keyChainManager.getToken())
                                    presentationMode.wrappedValue.dismiss()
                                    refreshData.toggle()                                    
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

extension UIImage {
    func compressTo(maxSizeInMB: Double) -> Data? {
        let maxSizeInBytes = Int(maxSizeInMB * 1024 * 1024)
        var compression: CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compression)

        while let data = imageData, data.count > maxSizeInBytes, compression > 0.1 {
            compression -= 0.1
            imageData = self.jpegData(compressionQuality: compression)
        }

        if let finalData = imageData, finalData.count <= maxSizeInBytes {
            return finalData
        } else {
            print("❌ Compression failed to meet the required size")
            return nil
        }
    }
}

#Preview {

    struct PreviewWrapper: View {
        @State private var refreshData: Bool = false
        var body: some View {
            let keyChainManager = KeychainManager()
            CreateCoffeeView(viewModel: CoffeeViewModel(), refreshData: $refreshData)
                .environmentObject(keyChainManager)
        }
    }

    return PreviewWrapper()
}
