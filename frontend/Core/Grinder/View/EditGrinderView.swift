//
//  EditGrinderView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 4/9/26.
//

import SwiftUI

struct EditGrinderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: GrinderViewModel

    @Binding var grinder: Grinder

    @State private var tempName: String
    @State private var validationError: String? = nil

    init(grinder: Binding<Grinder>) {
        self._grinder = grinder
        self._tempName = State(initialValue: grinder.wrappedValue.name)
    }

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            NavigationView {
                Form {
                    Section("Information") {
                        TextField("Name", text: $tempName)
                    }
                }
                .navigationTitle("Edit Grinder")
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
        guard viewModel.isValidName(name: tempName.trimmingCharacters(in: .whitespaces)) else {
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
            let input = GrinderInput(id: grinder.id, name: tempName.trimmingCharacters(in: .whitespaces))
            if let updated = await viewModel.updateGrinder(input: input, token: authViewModel.token ?? "") {
                grinder = updated
                dismiss()
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            EditGrinderView(grinder: .constant(Grinder.MOCK_GRINDER))
        }
    }
}
