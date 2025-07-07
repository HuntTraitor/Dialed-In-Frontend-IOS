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
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var region: Region = .none
    @State private var process: Process = .none
    @State private var description: String = ""
    @State private var decaf: Bool = false
    @State private var originType: OriginType = .unknown
    @State private var rating: Int = 0
    @State private var roastLevel: RoastLevel = .unknown
    @State private var cost: Double = 0.0
    @State private var imageSelection: PhotosPickerItem?
    @State private var imageObject: UIImage?
    @State private var imageData: Data?
    
//    private var isFormValid: Bool {
//        return (
//            viewModel.isValidName(name: coffeeName)
//            && viewModel.isValidRegion(region: coffeeRegion)
//            && viewModel.isValidProcess(process: coffeeProcess)
//            && viewModel.isValidDescription(description: coffeeDescription)
//        )
//    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    
                    Text("Add Coffee")
                    
                    
                    VStack(alignment: .leading, spacing: 16) {
                        if let imageObject {
                            VStack {
                                Image(uiImage: imageObject)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.top, 16)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                        
                        
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("background"))
                            PhotosPicker("Add a new image", selection: $imageSelection)
                            .onChange(of: imageSelection, initial: false) { oldValue, newValue in
                                Task(priority: .userInitiated) {
                                    if let newValue {
                                        if let loadedImageData = try? await newValue.loadTransferable(type: Data.self), let loadedImage = UIImage(data: loadedImageData) {
                                            if let resizedData = loadedImage.compressTo(maxSizeInKB: 1000) {
                                                DispatchQueue.main.async {
                                                    self.imageObject = UIImage(data: resizedData)
                                                    self.imageData = resizedData
                                                }
                                            } else {
                                                print("❌ Compression to 100 KB failed")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("General")
                                .font(.subheadline)
                                .foregroundColor(Color("background"))

                            LabeledTextField(label: "Name", text: $name, placeholder: "Add name")
                            Divider()
                            LabeledTextField(label: "Roaster", text: $roaster, placeholder: "Add roaster")
                            Divider()

                            HStack {
                                Text("Cost")
                                    .foregroundColor(.gray)
                                Spacer()
                                HStack {
                                    TextField("$0.00", value: $cost, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.primary)
                                }
                            }
                            Divider()
                        }
                        .cardStyle()
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Roast")
                                .font(.subheadline)
                                .foregroundColor(Color("background"))
                            
                            CustomOptionPicker(label: "Region", selection: $region)
                            Divider()

                            CustomOptionPicker(label: "Process", selection: $process)
                            Divider()
                            FixedOptionPicker(label: "Origin Type", selection: $originType)
                            Divider()
                            FixedOptionPicker(label: "Roast Level", selection: $roastLevel)
                            Divider()
                            HStack {
                                Text("Decaf?")
                                    .foregroundColor(.gray)
                                Spacer()
                                Button(action: {
                                    decaf.toggle()
                                }) {
                                    Image(systemName: decaf ? "checkmark.square.fill" : "square")
                                        .foregroundColor(decaf ? Color("background") : .gray)
                                        .font(.title3)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .cardStyle()
                        .padding(.horizontal)
                    }
                }
//                Form {
//                    Section {
//                        TextField("Name", text: $coffeeName)
//                        TextField("Region", text: $coffeeRegion)
//                        TextField("Process", text: $coffeeProcess)
//                    } header: {
//                        Text("Information")
//                    } footer: {
//                        Text("Please enter all information about the coffee below")
//                    }
//                    .headerProminence(.increased)
//                    
//                    Section("Coffee Image") {
//                        if let coffeeImageObject {
//                            VStack {
//                                Image(uiImage: coffeeImageObject)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 200, height: 200)
//                            }
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                        }
//                        PhotosPicker("Pick a coffee image", selection: $coffeeImageSelection)
//                            .onChange(of: coffeeImageSelection, initial: false) { oldValue, newValue in
//                                Task(priority: .userInitiated) {
//                                    if let newValue {
//                                        if let loadedImageData = try? await newValue.loadTransferable(type: Data.self),
//                                           let loadedImage = UIImage(data: loadedImageData) {
//                                            if let resizedData = loadedImage.compressTo(maxSizeInKB: 1000) {
//                                                DispatchQueue.main.async {
//                                                    self.coffeeImageObject = UIImage(data: resizedData)
//                                                    self.coffeeImageData = resizedData
//                                                }
//                                            } else {
//                                                print("❌ Compression to 100 KB failed")
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                    }
//                    
//                    Section("Coffee Description") {
//                        TextField("Description", text: $coffeeDescription, axis: .vertical)
//                    }
//                }
//                .navigationTitle("New Coffee")
//                .navigationBarTitleDisplayMode(.inline)
//                .navigationBarBackButtonHidden(true)
//                .toolbar {
//                    ToolbarItem(placement: .confirmationAction) {
//                        Button("Done") {
//                            Task {
//                                guard let imageData = coffeeImageData else {
//                                    print("❌ No image selected or failed to convert to Data")
//                                    return
//                                }
//                            
//                                let coffeeInput = CoffeeInput(
//                                    id: nil,
//                                    name: coffeeName,
//                                    decaff: false,
//                                    region: coffeeRegion,
//                                    process: coffeeProcess,
//                                    description: coffeeDescription,
//                                    img: imageData
//                                )
//                                
//                                print("📤 Uploading CoffeeInput with compressed image...")
//                                await viewModel.postCoffee(input: coffeeInput, token: authViewModel.token ?? "")
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                        }
//                        .disabled(!isFormValid)
//                    } 
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button("Cancel", role: .cancel) {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                }
            }
//            if viewModel.errorMessage != nil {
//                CustomDialog(
//                    isActive: .constant(true),
//                    title: "Error",
//                    message: viewModel.errorMessage ?? "An unknown error has occured.",
//                    buttonTitle: "Close",
//                    action: {viewModel.errorMessage = nil}
//                )
//            }
//            if viewModel.isLoading {
//                LoadingCircle()
//            }
        }
    }
}


#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    let mockCoffeeService = MockCoffeeService()
    let mockCoffeeViewModel = CoffeeViewModel(coffeeService: mockCoffeeService)
    CreateCoffeeView(viewModel: mockCoffeeViewModel)
        .environmentObject(authViewModel)
}
