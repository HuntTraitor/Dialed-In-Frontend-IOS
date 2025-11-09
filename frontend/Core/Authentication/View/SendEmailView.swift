//
//  SendEmailView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/9/25.
//

import SwiftUI

struct SendEmailView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var navigateToReset = false
    
    private var isFormValid: Bool {
        return viewModel.isValidEmail(email: email)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 150)
                    .padding(.top, 40)

                HStack(spacing: 8) {
                    Text("Enter your email address to receive a password reset code.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)

                VStack(spacing: 10) {
                    InputView(
                        text: $email,
                        icon: "envelope",
                        placeholder: "Enter Email"
                    )
                    .autocapitalization(.none)

                    Button {
                        Task {
                            await viewModel.sendPasswordEmail(email: email)
                            if viewModel.errorMessage == nil {
                                navigateToReset = true
                            }
                        }
                    } label: {
                        HStack {
                            Text("Send Email")
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
                }

                Spacer()
            }
            .padding(.horizontal)
            .disabled(viewModel.isLoading || viewModel.errorMessage != nil)
            .blur(radius: (viewModel.isLoading || viewModel.errorMessage != nil) ? 2 : 0)
            .navigationDestination(isPresented: $navigateToReset) {
                PasswordResetView()
            }

            if viewModel.isLoading {
                LoadingCircle()
                    .zIndex(1)
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
        }
    }

}

#Preview {
    PreviewWrapper {
        NavigationStack {
            SendEmailView()
        }
    }
}

