//
//  DialedInUITests.swift
//  DialedInUITests
//
//  Created by Hunter Tratar on 6/27/25.
//

import XCTest
import SimpleKeychain

final class DialedInUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let loginScreen = UIIdentifiers.LoginScreen.self
    let registrationScreen = UIIdentifiers.RegistrationScreen.self
    let homeScreen = UIIdentifiers.HomeScreen.self
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--reset-keychain")
        app.launchArguments.append("--use-dev-server")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func test_user_logs_in_successfully() throws {
        
        // type email
        let emailTextField = app.textFields[loginScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.com")

        // type password
        let passwordSecureTextField = app.secureTextFields[loginScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        // tap the signin button
        app.buttons[loginScreen.singinButton].tap()
        
        // check to see signin was successful
        let methodList = app.buttons[homeScreen.methodList]
        XCTAssertTrue(methodList.waitForExistence(timeout: 5), "Method list should exist on screen")
    }
    
    @MainActor
    func test_user_logs_in_with_incorrect_email() throws {
        // type email
        let emailTextField = app.textFields[loginScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("unknown@gmail.com")

        // type password
        let passwordSecureTextField = app.secureTextFields[loginScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        // tap the signin button
        app.buttons[loginScreen.singinButton].tap()
        
        // check to see signin was successful
        let errorDialog = app.buttons[loginScreen.errorDialogButton]
        XCTAssertTrue(errorDialog.waitForExistence(timeout: 5), "An error should appear on screen")
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        let found = allStaticTexts.contains { element in
            element.label.contains("account with that email")
        }
        XCTAssertTrue(found, "Expected substring not found in any static text")
    }
    
    @MainActor
    func test_user_logs_in_with_incorrect_password() throws {
        // type email
        let emailTextField = app.textFields[loginScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.com")

        // type password
        let passwordSecureTextField = app.secureTextFields[loginScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("incorrectpassword")
        
        // tap the signin button
        app.buttons[loginScreen.singinButton].tap()
        
        // check to see signin was successful
        let errorDialog = app.buttons[loginScreen.errorDialogButton]
        XCTAssertTrue(errorDialog.waitForExistence(timeout: 5), "An error should appear on screen")
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        let found = allStaticTexts.contains { element in
            element.label.contains("Invalid")
        }
        XCTAssertTrue(found, "Expected substring not found in any static text")
    }
    
    @MainActor
    func test_disabled_signin_button() throws {
        let signInButton = app.buttons[loginScreen.singinButton]
        
        let emailTextField = app.textFields[loginScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields[loginScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled")
        
        // hunter@gmail. should not work
        clearText(emailTextField)
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled")
        
        // huntergmail.com should not work
        clearText(emailTextField)
        emailTextField.tap()
        emailTextField.typeText("huntergmail.com")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled")
        
        // pass should not work
        clearText(emailTextField)
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.com")
        clearText(passwordSecureTextField)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("pass")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled")

        clearText(passwordSecureTextField)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled")
    }
}
