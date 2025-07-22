//
//  EditCoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/11/25.
//

import SwiftUI
import PhotosUI

struct EditCoffeeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CoffeeViewModel
    @Binding var coffee: Coffee
    @State private var imageSelection: PhotosPickerItem?
    @State private var imageObject: UIImage?
    @State private var imageData: Data?
    @State private var isShowingTastingNoteDialog = false
    
    @State private var tempName: String
    @State private var tempRoaster: String
    @State private var tempDecaf: Bool
    @State private var tempRegion: String
    @State private var tempProcess: String
    @State private var tempDescription: String
    @State private var tempOriginType: OriginType
    @State private var tempRating: Rating
    @State private var tempRoastLevel: RoastLevel
    @State private var tempTastingNotes: [TastingNote]
    @State private var tempCost: Double
    @State private var tempImg: String
    
    init(coffee: Binding<Coffee>) {
        self._coffee = coffee
        self._tempName = State(initialValue: coffee.wrappedValue.info.name)
        self._tempRoaster = State(initialValue: coffee.wrappedValue.info.roaster ?? "")
        self._tempDecaf = State(initialValue: coffee.wrappedValue.info.decaf)
        self._tempRegion = State(initialValue: coffee.wrappedValue.info.region ?? "")
        self._tempProcess = State(initialValue: coffee.wrappedValue.info.process ?? "")
        self._tempDescription = State(initialValue: coffee.wrappedValue.info.description ?? "")
        self._tempOriginType = State(initialValue: coffee.wrappedValue.info.originType ?? .unknown)
        self._tempRating = State(initialValue: coffee.wrappedValue.info.rating ?? .zero)
        self._tempRoastLevel = State(initialValue: coffee.wrappedValue.info.roastLevel ?? .unknown)
        self._tempTastingNotes = State(initialValue: coffee.wrappedValue.info.tastingNotes ?? [])
        self._tempCost = State(initialValue: coffee.wrappedValue.info.cost ?? 0)
        self._tempImg = State(initialValue: coffee.wrappedValue.info.img ?? "")
    }
    
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            NavigationView {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            headerSection
                            generalSection
                            roastSection
                            tasteSection
                            imageSection(proxy: proxy)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) { doneButton }
                        ToolbarItem(placement: .cancellationAction) { cancelButton }
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingCircle()
            }
            if viewModel.errorMessage != nil {
                CustomDialog(
                    isActive: .constant(viewModel.errorMessage != nil),
                    title: "Error",
                    message: viewModel.errorMessage ?? "An unexpected error has occurred",
                    buttonTitle: "Close",
                    action: { viewModel.errorMessage = nil }
                )
            }
        }
    }
    
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            Text("Edit Coffee")
                .padding(.vertical, 12)
                .padding(.leading, 24)
                .font(.title2)
                .bold()
            Spacer()
        }
    }
    
    // MARK: - General Section
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General")
                .font(.subheadline)
                .foregroundColor(Color("background"))

            LabeledTextField(label: "Name", text: $tempName, placeholder: "Add name")
            Divider()
            LabeledTextField(label: "Roaster", text: $tempRoaster, placeholder: "Add roaster")
            Divider()

            HStack {
                Text("Cost")
                    .foregroundColor(.gray)
                Spacer()
                TextField("$0.00", value: $tempCost, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
            }
            Divider()
        }
        .sectionCard()
    }
    
    // MARK: - Roast Section
    private var roastSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Roast")
                .font(.subheadline)
                .foregroundColor(Color("background"))

            LabeledTextField(label: "Region", text: $tempRegion, placeholder: "Add region")
            Divider()
            LabeledTextField(label: "Process", text: $tempProcess, placeholder: "Add process")
            Divider()
            FixedOptionPicker(label: "Origin Type", selection: $tempOriginType)
            Divider()
            FixedOptionPicker(label: "Roast Level", selection: $tempRoastLevel)
            Divider()

            HStack {
                Text("Decaf?")
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    tempDecaf.toggle()
                }) {
                    Image(systemName: tempDecaf ? "checkmark.square.fill" : "square")
                        .foregroundColor(tempDecaf ? Color("background") : .gray)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .sectionCard()
    }
    
    // MARK: - Taste Section
    private var tasteSection: some View {
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
                        let enumRating = Rating(rawValue: index)!
                        Button(action: {
                            tempRating = (tempRating == enumRating) ? .zero : enumRating
                        }) {
                            Image(systemName: tempRating.rawValue >= index ? "star.fill" : "star")
                                .foregroundColor(tempRating.rawValue >= index ? Color("background") : .gray)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Divider()

            HStack(alignment: .top) {
                Text("Tasting Notes")
                    .foregroundColor(.gray)
                Spacer()
                VStack {
                    if !tempTastingNotes.isEmpty {
                        TastingNotesView(notes: tempTastingNotes)
                    }

                    Button(action: {
                        isShowingTastingNoteDialog = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Add Notes")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color("background"))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $isShowingTastingNoteDialog) {
                        NavigationView {
                            TastingNotesDialog(selectedTastingNotes: $tempTastingNotes)
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
                TextEditor(text: $tempDescription)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(width: 210, height: 120)
            }
            Divider()
        }
        .sectionCard()
    }
    
    // MARK: - Image Section
    private func imageSection(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("background"))
                PhotosPicker("Add a new image", selection: $imageSelection)
                .onChange(of: imageSelection, initial: false) { _, newValue in
                    Task {
                        if let newValue,
                           let loadedImageData = try? await newValue.loadTransferable(type: Data.self),
                           let loadedImage = UIImage(data: loadedImageData),
                           let resizedData = loadedImage.compressTo(maxSizeInKB: 1000) {
                            self.imageObject = UIImage(data: resizedData)
                            self.imageData = resizedData

                            // Scroll to bottom after image loads
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                            }
                        } else {
                            print("❌ Image loading or compression failed")
                        }
                    }
                }
            }
            
            if let imageObject {
                Image(uiImage: imageObject)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 16)
            } else if !tempImg.isEmpty, let url = URL(string: tempImg) {
                ImageView(url)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 16)
            }

            Color.clear
                .frame(height: 1)
                .id("bottom")
        }
        .sectionCard()
    }
    
    // MARK: - Toolbar Buttons
    private var doneButton: some View {
        Button("Done") {
            Task {
                let imageData = imageData
                let coffeeInput = CoffeeInput(
                    id: coffee.id,
                    name: tempName,
                    roaster: tempRoaster,
                    region: tempRegion,
                    process: tempProcess,
                    description: tempDescription,
                    decaf: tempDecaf,
                    originType: tempOriginType,
                    rating: tempRating,
                    roastLevel: tempRoastLevel,
                    tastingNotes: tempTastingNotes,
                    cost: tempCost,
                    img: imageData
                )
                print("📤 Updating CoffeeInput with compressed image...")
                let updatedCoffee = await viewModel.updateCoffee(input: coffeeInput, token: authViewModel.token ?? "")

                guard let updatedCoffee else {
                    print("❌ Update failed: no coffee returned")
                    return
                }

                coffee.info.name = updatedCoffee.info.name
                coffee.info.roaster = updatedCoffee.info.roaster
                coffee.info.region = updatedCoffee.info.region
                coffee.info.process = updatedCoffee.info.process
                coffee.info.description = updatedCoffee.info.description
                coffee.info.decaf = updatedCoffee.info.decaf
                coffee.info.originType = updatedCoffee.info.originType
                coffee.info.rating = updatedCoffee.info.rating
                coffee.info.roastLevel = updatedCoffee.info.roastLevel
                coffee.info.tastingNotes = updatedCoffee.info.tastingNotes
                coffee.info.cost = updatedCoffee.info.cost
                coffee.info.img = updatedCoffee.info.img
                
                dismiss()
            }
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var refreshData: Bool = false
        @State private var sampleCoffee = Coffee(
            id: 1,
            userId: 1,
            info: CoffeeInfo(
                name: "Ethiopian Yirgacheffe",
                decaf: false,
                region: "Ethiopia",
                process: "Washed",
                description: "Bright and floral with notes of citrus and jasmine",
                originType: .singleOrigin,
                img: "https://media.istockphoto.com/id/484234714/vector/example-free-grunge-retro-blue-isolated-stamp.jpg?s=612x612&w=0&k=20&c=97KgKGpcAKnn50Ubd8PawjUybzIesoXws7PdU_MJGzE="
            )
        )

        var body: some View {
            let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
            let viewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))

            EditCoffeeView(
                coffee: $sampleCoffee
            )
            .environmentObject(authViewModel)
        }
    }

    return PreviewWrapper()
}
