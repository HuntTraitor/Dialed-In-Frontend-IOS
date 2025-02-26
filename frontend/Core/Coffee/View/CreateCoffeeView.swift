//
//  CreateCoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/17/25.
//

import SwiftUI
import PhotosUI

struct CreateCoffeeView: View {
    @State private var coffeeName: String = ""
    @State private var coffeeRegion: String = ""
    @State private var coffeeProcess: String = ""
    @State private var coffeeDescription: String = ""
    @State private var coffeeImageSelection: PhotosPickerItem?
    @State private var coffeeImageObject: UIImage?
    var body: some View {
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
                                        self.coffeeImageObject = loadedImage
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
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    CreateCoffeeView()
}
