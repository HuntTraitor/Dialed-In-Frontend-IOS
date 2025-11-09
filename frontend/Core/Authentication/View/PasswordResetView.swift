//
//  PasswordResetView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/9/25.
//

import SwiftUI

struct PasswordResetView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var code = ""
    
    private var isFormValid: Bool {
        return viewModel.isValidPassword(password: password)
        && password == confirmPassword && viewModel.isValidCode(code: code)
    }

    var body: some View {
        VStack(spacing: 24) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 150)
                .padding(.top, 40)

            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
                Text("A reset code has been sent to your email.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)

            VStack(spacing: 10) {
                InputView(
                    text: $code,
                    icon: "keyboard",
                    placeholder: "Enter password reset code",
                    keyboardType: .numberPad
                )
                InputView(
                    text: $password,
                    icon: "lock",
                    placeholder: "Enter New Password",
                    isSecureField: true
                )
                .autocapitalization(.none)
                InputView(
                    text: $confirmPassword,
                    icon: "lock",
                    placeholder: "Re-Enter New Password",
                    isSecureField: true
                )
                
                Button {
//                    isLoading = true
                    Task {
//                        await viewModel.signIn(email: email, password: password)
//                        if viewModel.session != nil {
//                            isSuccessDialogActive = true
//                        }
//                        isLoading = false
                    }
                } label: {
                    HStack {
                        Text("Reset Password")
                            .fontWeight(.semibold)
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
            }
            .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    PreviewWrapper {
        NavigationStack {
            PasswordResetView()
        }
    }
}

