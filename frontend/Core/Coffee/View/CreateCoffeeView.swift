////
////  CreateCoffeeView.swift
////  DialedIn
////
////  Created by Hunter Tratar on 2/17/25.
////
//
//import SwiftUI
//import PhotosUI
//
//struct CreateCoffeeView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @ObservedObject var viewModel: CoffeeViewModel
//    @State private var coffeeName: String = ""
//    @State private var coffeeRegion: String = ""
//    @State private var coffeeProcess: String = ""
//    @State private var coffeeDescription: String = ""
//    @State private var coffeeImageSelection: PhotosPickerItem?
//    @State private var coffeeImageObject: UIImage?
//    @State private var coffeeImageData: Data?
//    
//    private var isFormValid: Bool {
//        return (
//            viewModel.isValidName(name: coffeeName)
//            && viewModel.isValidRegion(region: coffeeRegion)
//            && viewModel.isValidProcess(process: coffeeProcess)
//            && viewModel.isValidDescription(description: coffeeDescription)
//        )
//    }
//
//    var body: some View {
//        ZStack {
//            NavigationView {
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
//            }
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
//        }
//    }
//}
//
//#Preview {
//    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
//    let viewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))
//    CreateCoffeeView(viewModel: viewModel)
//        .environmentObject(authViewModel)
//}
