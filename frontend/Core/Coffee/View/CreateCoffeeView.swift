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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: CoffeeViewModel
    @State private var isShowingTastingNoteDialog = false
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
    @State private var tasteNotes: [TastingNote] = []
    @State private var imageSelection: PhotosPickerItem?
    @State private var imageObject: UIImage?
    @State private var imageData: Data?

    var body: some View {
        ZStack {
            NavigationView {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Add Coffee")
                                    .padding(.vertical, 12)
                                    .padding(.leading, 24)
                                Spacer()
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

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Taste")
                                    .font(.subheadline)
                                    .foregroundColor(Color("background"))

                                HStack {
                                    Text("Rating")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    HStack {
                                        ForEach(1...5, id: \.self) { index in
                                            Button(action: {
                                                rating = (rating == index) ? 0 : index
                                            }) {
                                                Image(systemName: index <= rating ? "star.fill" : "star")
                                                    .foregroundColor(index <= rating ? Color("background") : .gray)
                                                    .font(.body)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }

                                Divider()

                                HStack(alignment: .top) {
                                    Text("Tasting Notes")
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    VStack(alignment: .center) {
                                        if !tasteNotes.isEmpty {
                                            TastingNotesView(notes: tasteNotes)
                                        }
                                        Button(action: {
                                            isShowingTastingNoteDialog = true
                                        }) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "plus")
                                                    .font(.system(size: 14, weight: .bold))
                                                Text("Add Notes")
                                                    .font(.system(size: 14))
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundColor(Color("background"))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .sheet(isPresented: $isShowingTastingNoteDialog) {
                                            NavigationView {
                                                TastingNotesDialog(selectedTastingNotes: $tasteNotes)
                                                    .toolbar {
                                                        ToolbarItem(placement: .confirmationAction) {
                                                            Button("Close") {
                                                                isShowingTastingNoteDialog = false
                                                            }
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                                Divider()

                                HStack(alignment: .top) {
                                    Text("Notes")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    ScrollView {
                                        TextEditor(text: $description)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                            .scrollContentBackground(.hidden)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(10)
                                            .frame(height: 120)
                                    }
                                    .frame(width: 210, height: 120)
                                }
                                Divider()
                            }
                            .cardStyle()
                            .padding(.horizontal)

                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color("background"))
                                    PhotosPicker("Add a new image", selection: $imageSelection)
                                        .onChange(of: imageSelection, initial: false) { _, newValue in
                                            Task(priority: .userInitiated) {
                                                if let newValue,
                                                   let loadedImageData = try? await newValue.loadTransferable(type: Data.self),
                                                   let loadedImage = UIImage(data: loadedImageData),
                                                   let resizedData = loadedImage.compressTo(maxSizeInKB: 1000) {
                                                    DispatchQueue.main.async {
                                                        self.imageObject = UIImage(data: resizedData)
                                                        self.imageData = resizedData
                                                    }
                                                } else {
                                                    print("❌ Image loading or compression failed")
                                                }
                                            }
                                        }
                                }

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

                                Color.clear
                                    .frame(height: 1)
                                    .id("bottom")
                            }
                        }
                        .onChange(of: imageObject) { _, _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                dismiss()
                            }
                        }

                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                    }
                }
            }
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

////                    ToolbarItem(placement: .confirmationAction) {
////                        Button("Done") {
////                            Task {
////                                guard let imageData = coffeeImageData else {
////                                    print("❌ No image selected or failed to convert to Data")
////                                    return
////                                }
////
////                                let coffeeInput = CoffeeInput(
////                                    id: nil,
////                                    name: coffeeName,
////                                    decaff: false,
////                                    region: coffeeRegion,
////                                    process: coffeeProcess,
////                                    description: coffeeDescription,
////                                    img: imageData
////                                )
////
////                                print("📤 Uploading CoffeeInput with compressed image...")
////                                await viewModel.postCoffee(input: coffeeInput, token: authViewModel.token ?? "")
////                                presentationMode.wrappedValue.dismiss()
////                            }
////                        }
////                        .disabled(!isFormValid)
////                    }
////                    ToolbarItem(placement: .navigationBarLeading) {
////                        Button("Cancel", role: .cancel) {
////                            presentationMode.wrappedValue.dismiss()
////                        }
////                    }
////                }
