//
//  RegistrationView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/11/24.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss
    @State var isSuccessDialogActive: Bool = false
    
    private let testingID = UIIdentifiers.RegistrationScreen.self
    
    private var isFormValid: Bool {
        return
            viewModel.isValidEmail(email: email)
            && viewModel.isValidName(name: name)
            && viewModel.isValidPassword(password: password)
            && viewModel.isValidConfirmPassword(password: password, confirmPassword: confirmPassword)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 180)
                    .padding(.vertical, 32)
                
                VStack {
                    InputView(
                        text: $name,
                        icon: "person",
                        placeholder: "Enter Username"
                    )
                        .autocapitalization(.none)
                        .accessibilityIdentifier(testingID.nameInput)
                    
                    InputView(
                        text: $email,
                        icon: "envelope",
                        placeholder: "Enter Email"
                    )
                        .autocapitalization(.none)
                        .accessibilityIdentifier(testingID.emailInput)
                    
                    InputView(
                        text: $password,
                        icon: "lock",
                        placeholder: "Enter Password",
                        isSecureField: true
                    )
                        .autocapitalization(.none)
                        .textContentType(.none)
                        .accessibilityIdentifier(testingID.passwordInput)
                    
                    InputView(
                        text: $confirmPassword,
                        icon: "lock",
                        placeholder: "Confirm Password",
                        isSecureField: true
                    )
                    .accessibilityIdentifier(testingID.confirmPasswordInput)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    isLoading = true
                    Task {
                        await viewModel.createUser(email: email, password: password, name: name)
                        if viewModel.errorMessage == nil {
                            isSuccessDialogActive = true
                        }
                        isLoading = false
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .opacity(isFormValid ? 1 : 0.5)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 180, height: 48)
                }
                .background(Color("background"))
                .cornerRadius(30)
                .padding(.top, 24)
                .disabled(!isFormValid)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 6)
                .accessibilityIdentifier(testingID.registerButton)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.left")
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color("background"))
                    .font(.system(size: 14))
                }
                .accessibilityIdentifier(testingID.loginSwitchButton)
            }
            if isSuccessDialogActive {
                CustomDialog(
                    isActive: $isSuccessDialogActive,
                    title: "Success",
                    message: "Your registration was successful. Please log in!",
                    buttonTitle: "Close",
                    action: {
                        isSuccessDialogActive = false
                        dismiss()
                    }
                )
                .accessibilityIdentifier(testingID.successDialogButton)
            }
            if viewModel.errorMessage != nil {
                CustomDialog(
                    isActive: $isSuccessDialogActive,
                    title: "Error",
                    message: viewModel.errorMessage ?? "An unexpected error has occured",
                    buttonTitle: "Close",
                    action: {viewModel.errorMessage = nil}
                )
                .accessibilityIdentifier(testingID.errorDialogButton)
            }
            if isLoading {
                LoadingCircle()
            }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    return RegistrationView()
        .environmentObject(viewModel)
}


