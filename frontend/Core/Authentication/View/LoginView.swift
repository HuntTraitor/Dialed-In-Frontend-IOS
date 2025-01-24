//
//  LoginView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var signinToken = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var keychainManager: KeychainManager
    @State var isSuccessDialogActive: Bool = false
    @State var isErrorDialogActive: Bool = false
    @State var errorMessage: String?
    
    private var isFormValid: Bool {
        return
            viewModel.isValidEmail(email: email)
        && viewModel.isValidPassword(password: password)
    }
    
    var body: some View {
        NavigationStack {
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
                        
                        InputView(
                            text: $password,
                            icon: "lock",
                            placeholder: "Enter Password",
                            isSecureField: true
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    Button {
                        isLoading = true
                        Task {
                            let result: SignInResult
                            do {
                            result = try await viewModel.signIn(withEmail: email, password: password)
                            } catch {
                                errorMessage = "An unknown error occured."
                                isErrorDialogActive = true
                                isLoading = false
                                return
                            }
                            
                            
                            switch result {
                            case .token(let token):
                                isLoading = false
                                isSuccessDialogActive = true
                                signinToken = token.token
                            case .error(let error):
                                if let errorMessageRaw = error["error"] as? String {
                                    if errorMessageRaw.contains("could not be found") {
                                        errorMessage = "An account with this email address does not exist."
                                    } else if errorMessageRaw.contains("invalid authentication") {
                                        errorMessage = "Incorrect credentials, please try again"
                                    }
                                } else {
                                    errorMessage = "An unknown error occurred."
                                }
                                isErrorDialogActive = true
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
                    
                    NavigationLink {
                        
                    } label: {
                        Text("forgot password?")
                            .font(.system(size: 14))
                            .padding(10)
                            .fontWeight(.bold)
                            .foregroundColor(Color("background"))
                    }
                    
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
                }
                if isSuccessDialogActive {
                    CustomDialog(
                        isActive: $isSuccessDialogActive,
                        title: "Success",
                        message: "Your login was successful!",
                        buttonTitle: "Close",
                        action: {
                            keychainManager.saveToken(signinToken)
                            isSuccessDialogActive = false
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        @StateObject var keychainManager = KeychainManager()
        LoginView()
            .environmentObject(viewModel)
            .environmentObject(keychainManager)
    }
}
