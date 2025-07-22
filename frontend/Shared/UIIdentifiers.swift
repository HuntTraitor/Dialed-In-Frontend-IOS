//
//  UIIdentifiers.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/3/25.
//

import Foundation

enum UIIdentifiers {
    
    enum Components {
        static let confirmDialogButton = "Components.button.confirmDialogButton"
        static let choiceDialogAcceptButton = "Components.button.choiceDialogAcceptButton"
        static let choiceDialogRejectButton = "Components.button.choiceDialogRejectButton"
    }
    
    enum LoginScreen {
        static let emailInput = "LoginScreen.emailInput"
        static let passwordInput = "LoginScreen.passwordInput"
        static let singinButton = "LoginScreen.button.singinButton"
        static let forgotPasswordButton = "LoginScreen.button.forgotPasswordButton"
        static let registrationSwitchButton = "LoginScreen.button.registrationSwitchButton"
        static let errorDialog = "LoginScreen.dialog.errorDialog"
    }
    
    enum RegistrationScreen {
        static let nameInput = "RegistrationScreen.nameInput"
        static let emailInput = "RegistrationScreen.emailInput"
        static let passwordInput = "RegistrationScreen.passwordInput"
        static let confirmPasswordInput = "RegistrationScreen.confirmPasswordInput"
        static let registerButton = "RegistrationScreen.button.registerButton"
        static let loginSwitchButton = "RegistrationScreen.button.loginSwitchButton"
        static let successDialog = "RegistrationScreen.dialog.successDialog"
        static let errorDialog = "RegistrationScreen.dialog.errorDialog"
    }
    
    enum HomeScreen {
        static let methodList = "HomeScreen.methodList"
        static let coffeeNavigationButton = "HomeScreen.button.coffeeNavigationButton"
        static let homeNavigationButton = "HomeScreen.button.homeNavigationButton"
        static let profileNavigationButton = "HomeScreen.button.profileNavigationButton"
        static let recipeNavigationButton = "HomeScreen.button.recipeNavigationButton"
    }
    
    enum CoffeeScreen {
        static let coffeesTitle = "CoffeeScreen.coffeesTitle"
    }
    
    enum MethodScreen {
        static let methodTitle = "MethodScreen.methodTitle"
    }
}

