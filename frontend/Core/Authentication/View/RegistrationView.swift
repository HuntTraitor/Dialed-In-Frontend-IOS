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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
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
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password")
                .autocapitalization(.none)
                
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password")
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, name: name)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color("background"))
            .cornerRadius(10)
            .padding(.top, 24)
            
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
    }
}

struct RegistrationView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var viewModel = AuthViewModel()
        RegistrationView()
            .environmentObject(viewModel)
    }
}


