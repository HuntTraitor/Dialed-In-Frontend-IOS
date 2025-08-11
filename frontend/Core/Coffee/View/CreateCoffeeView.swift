//
//  CreateCoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/17/25.
//

import SwiftUI
import PhotosUI

struct CreateCoffeeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CoffeeViewModel

    @State private var isShowingTastingNoteDialog = false
    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var region: String = ""
    @State private var process: String = ""
    @State private var description: String = ""
    @State private var decaf: Bool = false
    @State private var originType: OriginType = .unknown
    @State private var rating: Rating = .zero
    @State private var roastLevel: RoastLevel = .unknown
    @State private var cost: Double = 0.0
    @State private var tasteNotes: [TastingNote] = []
    @State private var imageSelection: PhotosPickerItem?
    @State private var imageObject: UIImage?
    @State private var imageData: Data?
    @State private var validationError: String? = nil


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
            Text("Add Coffee")
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

            LabeledTextField(label: "Name", text: $name, placeholder: "Add name")
            Divider()
            LabeledTextField(label: "Roaster", text: $roaster, placeholder: "Add roaster")
            Divider()

            HStack {
                Text("Cost")
                    .foregroundColor(.gray)
                Spacer()
                TextField("$0.00", value: $cost, format: .number)
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

            LabeledTextField(label: "Region", text: $region, placeholder: "Add region")
            Divider()
            LabeledTextField(label: "Process", text: $process, placeholder: "Add process")
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
                            rating = (rating == enumRating) ? .zero : enumRating
                        }) {
                            Image(systemName: rating.rawValue >= index ? "star.fill" : "star")
                                .foregroundColor(rating.rawValue >= index ? Color("background") : .gray)
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
                    if !tasteNotes.isEmpty {
                        TastingNotesView(notes: tasteNotes)
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
                TextEditor(text: $description)
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
                if let validationError = validateCoffeeInput() {
                    self.validationError = validationError
                    return
                }
                
                let coffeeInput = CoffeeInput(
                    id: nil,
                    name: name,
                    roaster: roaster,
                    region: region,
                    process: process,
                    description: description,
                    decaf: decaf,
                    originType: originType,
                    rating: rating,
                    roastLevel: roastLevel,
                    tastingNotes: tasteNotes,
                    cost: cost,
                    img: imageData
                )
                
                print("posted with \(coffeeInput)")
                
                await viewModel.postCoffee(input: coffeeInput, token: authViewModel.token ?? "")
                
                print(viewModel.errorMessage ?? "No error message")

            }
            dismiss()
        }
        .disabled(!isFormValid)
    }
    
    private func validateCoffeeInput() -> String? {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return "Coffee name must be provided."
        }
        return nil
    }

    var isFormValid: Bool {
        return validateCoffeeInput() == nil
    }

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
}

// MARK: - Styling Extension
extension View {
    func sectionCard() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    PreviewWrapper {
        CreateCoffeeView()
    }
}
