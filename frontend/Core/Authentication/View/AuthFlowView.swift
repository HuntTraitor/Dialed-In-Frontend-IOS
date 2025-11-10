//
//  AuthFlowView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/9/25.
//

import SwiftUI

struct AuthFlowView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(
                onForgotPassword: {
                    path.append(AuthRoute.sendEmail)
                },
                onRegister: {
                    path.append(AuthRoute.register)
                }
            )
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .sendEmail:
                    SendEmailView(path: $path)
                case .resetPassword:
                    PasswordResetView(path: $path)
                case .register:
                    RegistrationView()
                }
            }
        }
    }
}

#Preview {
    PreviewWrapper {
        AuthFlowView()
    }
}


