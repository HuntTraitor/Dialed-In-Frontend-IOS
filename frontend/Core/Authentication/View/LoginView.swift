//
//  LoginView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var signinToken = ""
    @State var isSuccessDialogActive: Bool = false
    
    private let testingID = UIIdentifiers.LoginScreen.self
    
    private var isFormValid: Bool {
        return
            viewModel.isValidEmail(email: email)
        && viewModel.isValidPassword(password: password)
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
                        .accessibilityIdentifier(testingID.passwordInput)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    Button {
                        isLoading = true
                        Task {
                            await viewModel.signIn(email: email, password: password)
                            if viewModel.session != nil {
                                isSuccessDialogActive = true
                            }
                            isLoading = false
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN")
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
                    .accessibilityIdentifier(testingID.singinButton)
                    
                    NavigationLink {
                        SendEmailView()
                    } label: {
                        Text("forgot password?")
                            .font(.system(size: 14))
                            .padding(10)
                            .fontWeight(.bold)
                            .foregroundColor(Color("background"))
                    }
                    .accessibilityIdentifier(testingID.forgotPasswordButton)
                    
                    Spacer()
                    
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Dont have an account?")
                            Text("Sign up")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(Color("background"))
                        .font(.system(size: 14))
                    }
                    .accessibilityIdentifier(testingID.registrationSwitchButton)
                }
                if viewModel.errorMessage != nil {
                    CustomDialog(
                        isActive: $isSuccessDialogActive,
                        title: "Error",
                        message: viewModel.errorMessage ?? "An unexpected error has occured",
                        buttonTitle: "Close",
                        action: {viewModel.errorMessage = nil}
                    )
                }
                if isLoading {
                    LoadingCircle()
                }
            }
        }
    
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            LoginView()
        }
    }
}
