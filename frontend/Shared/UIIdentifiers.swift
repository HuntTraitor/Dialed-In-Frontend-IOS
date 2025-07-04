//
//  UIIdentifiers.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/3/25.
//

import Foundation

enum UIIdentifiers {
    
    enum LoginScreen {
        static let emailInput = "LoginScreen.emailInput"
        static let passwordInput = "LoginScreen.passwordInput"
        static let singinButton = "LoginScreen.button.singinButton"
        static let forgotPasswordButton = "LoginScreen.button.forgotPasswordButton"
        static let registrationSwitchButton = "LoginScreen.button.registrationSwitchButton"
        static let errorDialogButton = "LoginScreen.dialog.errorDialogButton"
    }
    
    enum RegistrationScreen {
        static let nameInput = "RegistrationScreen.nameInput"
        static let emailInput = "RegistrationScreen.emailInput"
        static let passwordInput = "RegistrationScreen.passwordInput"
        static let confirmPasswordInput = "RegistrationScreen.confirmPasswordInput"
        static let registerButton = "RegistrationScreen.button.registerButton"
        static let loginSwitchButton = "RegistrationScreen.button.loginSwitchButton"
        static let successDialogButton = "LoginScreen.dialog.successDialogButton"
        static let errorDialogButton = "LoginScreen.dialog.errorDialogButton"
    }
    
    enum HomeScreen {
        static let methodList = "HomeScreen.methodList"
    }
}

