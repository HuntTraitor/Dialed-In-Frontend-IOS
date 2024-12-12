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
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                        
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN")
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
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        LoginView()
            .environmentObject(viewModel)
    }
}
