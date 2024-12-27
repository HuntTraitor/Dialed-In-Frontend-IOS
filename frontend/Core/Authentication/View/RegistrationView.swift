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
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isSuccessDialogActive: Bool = false
    @State var isErrorDialogActive: Bool = false
    @State var errorMessage: String?
    
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
                
                VStack(spacing: 24) {
                    InputView(text: $name, title: "Name", placeholder: "Enter your name")
                        .autocapitalization(.none)
                    
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .autocapitalization(.none)
                        .textContentType(.none)
                    
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    isLoading = true
                    Task {
                        let result = try await viewModel.createUser(withEmail: email, password: password, name: name)
                    
                        switch result {
                        case .user:
                            isLoading = false
                            isSuccessDialogActive = true
                        case .error(let error):
                            // uppercase the first letter of the error
                            if let email = error["email"] as? String {
                                errorMessage = email.prefix(1).uppercased() + email.dropFirst()
                            }
                            isLoading = false
                            isErrorDialogActive = true
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .opacity(isFormValid ? 1 : 0.5)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color("background"))
                .cornerRadius(10)
                .padding(.top, 24)
                .disabled(!isFormValid)
                
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
                CustomDialog(isActive: $isSuccessDialogActive, title: "Success", message: "Your registration was successful!", buttonTitle: "Close", action: {isSuccessDialogActive = false})
            }
            if isErrorDialogActive {
                CustomDialog(isActive: $isSuccessDialogActive, title: "Error", message: errorMessage ?? "An unexpected error has occured", buttonTitle: "Close", action: {isErrorDialogActive = false})
            }
            if isLoading {
                LoadingCircle()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        RegistrationView()
            .environmentObject(viewModel)
    }
}


