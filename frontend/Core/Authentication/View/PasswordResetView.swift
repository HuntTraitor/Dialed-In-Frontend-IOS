//
//  PasswordResetView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/9/25.
//

import SwiftUI

struct PasswordResetView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var path: NavigationPath

    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var code = ""
    @State private var showSuccessDialog = false
    
    private var isFormValid: Bool {
        viewModel.isValidPassword(password: password) &&
        password == confirmPassword &&
        viewModel.isValidCode(code: code)
    }

    var body: some View {
        let overlayActive = viewModel.isLoading || viewModel.errorMessage != nil || showSuccessDialog

        ZStack {
            VStack(spacing: 24) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 150)
                    .padding(.top, 40)
                
                HStack(spacing: 8) {
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
                        Task {
                            await viewModel.resetPassword(password: password, code: code)
                            if viewModel.errorMessage == nil {
                                showSuccessDialog = true
                            }
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
            .disabled(overlayActive)
            .blur(radius: overlayActive ? 2 : 0)
            
            if viewModel.isLoading {
                LoadingCircle()
            }

            if viewModel.errorMessage != nil {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .zIndex(2)

                CustomDialog(
                    isActive: .constant(true),
                    title: "Error",
                    message: viewModel.errorMessage ?? "An unexpected error has occurred",
                    buttonTitle: "Close",
                    action: { viewModel.errorMessage = nil }
                )
                .zIndex(3)
            }

            if showSuccessDialog {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .zIndex(2)

                CustomDialog(
                    isActive: $showSuccessDialog,
                    title: "Success",
                    message: "Your password has been reset. Please use your new password to log in.",
                    buttonTitle: "OK",
                    action: {
                        showSuccessDialog = false
                        path.removeLast(path.count)   // 👈 go all the way back to Login
                    }
                )
                .zIndex(3)
            }
        }
    }
}



//#Preview {
//    PreviewWrapper {
//        NavigationStack {
//            PasswordResetView()
//        }
//    }
//}

