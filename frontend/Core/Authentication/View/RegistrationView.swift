//
//  RegistrationView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/11/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel = AuthViewModel()
    @State var isSuccessDialogActive: Bool = false
    @State var isErrorDialogActive: Bool = false
    @State var errorMessage: String?
    
    private var isFormValid: Bool {
        return
            authViewModel.isValidEmail(email: email)
            && authViewModel.isValidName(name: name)
            && authViewModel.isValidPassword(password: password)
            && authViewModel.isValidConfirmPassword(password: password, confirmPassword: confirmPassword)
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
                    
                    InputView(
                        text: $email,
                        icon: "envelope",
                        placeholder: "Enter Email"
                    )
                        .autocapitalization(.none)
                    
                    InputView(
                        text: $password,
                        icon: "lock",
                        placeholder: "Enter Password",
                        isSecureField: true
                    )
                        .autocapitalization(.none)
                        .textContentType(.none)
                    
                    InputView(
                        text: $confirmPassword,
                        icon: "lock",
                        placeholder: "Confirm Password",
                        isSecureField: true
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    isLoading = true
                    Task {
                        let result: CreateUserResult
                        do {
                            result = try await authViewModel.createUser(withEmail: email, password: password, name: name)
                        } catch {
                            errorMessage = "An unknown error occured."
                            isErrorDialogActive = true
                            isLoading = false
                            return
                        }
                    
                        switch result {
                        case .user:
                            isLoading = false
                            isSuccessDialogActive = true
                        case .error(let error):
                            if let email = error["email"] as? String {
                                errorMessage = email.prefix(1).uppercased() + email.dropFirst()
                            } else {
                                errorMessage = "An unknown error occurred."
                            }
                            isErrorDialogActive = true
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
            }
            if isErrorDialogActive {
                CustomDialog(
                    isActive: $isSuccessDialogActive,
                    title: "Error",
                    message: errorMessage ?? "An unexpected error has occured",
                    buttonTitle: "Close",
                    action: {isErrorDialogActive = false}
                )
            }
            if isLoading {
                LoadingCircle()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}


