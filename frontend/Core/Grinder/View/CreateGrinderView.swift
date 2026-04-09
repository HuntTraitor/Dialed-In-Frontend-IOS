//
//  CreateGrinderView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 4/9/26.
//

import SwiftUI

struct CreateGrinderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: GrinderViewModel

    @State private var name: String = ""
    @State private var validationError: String? = nil

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            NavigationView {
                Form {
                    Section("Information") {
                        TextField("Name", text: $name)
                    }
                }
                .navigationTitle("Add Grinder")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { save() }
                            .disabled(!isFormValid)
                    }
                }
            }
            if viewModel.isLoading {
                LoadingCircle()
            }
        }
        .alert("Validation Error", isPresented: .constant(validationError != nil), actions: {
            Button("OK", role: .cancel) { validationError = nil }
        }, message: {
            if let message = validationError { Text(message) }
        })
    }

    private var isFormValid: Bool {
        return validateInput() == nil
    }

    private func validateInput() -> String? {
        guard viewModel.isValidName(name: name.trimmingCharacters(in: .whitespaces)) else {
            return "Name must be between 1 and 500 characters."
        }
        return nil
    }

    private func save() {
        Task {
            if let error = validateInput() {
                validationError = error
                return
            }
            let input = GrinderInput(id: nil, name: name.trimmingCharacters(in: .whitespaces))
            await viewModel.postGrinder(input: input, token: authViewModel.token ?? "")
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack { CreateGrinderView() }
    }
}
