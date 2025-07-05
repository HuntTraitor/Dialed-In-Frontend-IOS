//
//  DialedInUITests.swift
//  DialedInUITests
//
//  Created by Hunter Tratar on 6/27/25.
//

import XCTest

final class AuthUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let loginScreen = UIIdentifiers.LoginScreen.self
    let registrationScreen = UIIdentifiers.RegistrationScreen.self
    let homeScreen = UIIdentifiers.HomeScreen.self
    let components = UIIdentifiers.Components.self
    let coffeeScreen = UIIdentifiers.CoffeeScreen.self
    let methodScreen = UIIdentifiers.MethodScreen.self
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--reset-keychain")
        app.launchArguments.append(contentsOf: ["-UITest", "no-animations"])
        app.launchEnvironment["-base-url"] = "http://localhost:3000/v1/"
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
        let methodList = app.staticTexts[methodScreen.methodTitle]
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
        
        // check to see signin was unsuccessful
        let successText = app.staticTexts["Error"]
        XCTAssertTrue(successText.waitForExistence(timeout: 5), "SuccessDialog should appear on screen")
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
        
        // check to see signin was unsuccessful
        let successText = app.staticTexts["Error"]
        XCTAssertTrue(successText.waitForExistence(timeout: 5), "SuccessDialog should appear on screen")
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
        replaceText(emailTextField, with: "hunter@gmail.")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled")
        
        // huntergmail.com should not work
        replaceText(emailTextField, with: "huntergmail.com")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled")
        
        // pass should not work
        replaceText(emailTextField, with: "hunter@gmail.com")
        replaceText(passwordSecureTextField, with: "pass")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled")

        replaceText(passwordSecureTextField, with: "password")
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled")
    }
    
    @MainActor
    func test_register_user_successful() throws {
        // switch to registration
        app.buttons[loginScreen.registrationSwitchButton].tap()
        XCTAssertTrue(app.buttons[registrationScreen.registerButton].exists)
        
        let nameTextField = app.textFields[registrationScreen.nameInput]
        nameTextField.tap()
        nameTextField.typeText("Test User")
        
        let emailTextField = app.textFields[registrationScreen.emailInput]
        emailTextField.tap()
        let uuid = UUID().uuidString.prefix(8)
        let email = "testuser\(uuid)@gmail.com"
        emailTextField.typeText(email)
        
        let passwordSecureTextField = app.secureTextFields[registrationScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        let confirmPasswordSecureTextField = app.secureTextFields[registrationScreen.confirmPasswordInput]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("password")
        
        let registerButton = app.buttons[registrationScreen.registerButton]
        XCTAssertTrue(registerButton.isEnabled, "Register button should be enabled")
        app.buttons[registrationScreen.registerButton].tap()
        
        let successText = app.staticTexts["Success"]
        XCTAssertTrue(successText.waitForExistence(timeout: 5), "SuccessDialog should appear on screen")
        
        app.buttons[components.confirmDialogButton].tap()
        
        XCTAssertTrue(app.buttons[loginScreen.singinButton].exists)
    }
    
    @MainActor
    func test_register_user_email_already_exists() throws {
        
        // -------------- FIRST REGISTRATION SUCCESS
        app.buttons[loginScreen.registrationSwitchButton].tap()
        XCTAssertTrue(app.buttons[registrationScreen.registerButton].exists)
        
        var nameTextField = app.textFields[registrationScreen.nameInput]
        nameTextField.tap()
        nameTextField.typeText("Test User")
        
        var emailTextField = app.textFields[registrationScreen.emailInput]
        emailTextField.tap()
        let uuid = UUID().uuidString.prefix(8)
        var email = "testuser\(uuid)@gmail.com"
        emailTextField.typeText(email)
        
        var passwordSecureTextField = app.secureTextFields[registrationScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        var confirmPasswordSecureTextField = app.secureTextFields[registrationScreen.confirmPasswordInput]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("password")
        
        var registerButton = app.buttons[registrationScreen.registerButton]
        XCTAssertTrue(registerButton.isEnabled, "Register button should be enabled")
        app.buttons[registrationScreen.registerButton].tap()
        
        var successText = app.staticTexts["Success"]
        XCTAssertTrue(successText.waitForExistence(timeout: 5), "Success should appear on screen")
        
        app.buttons[components.confirmDialogButton].tap()
        
        XCTAssertTrue(app.buttons[loginScreen.singinButton].exists)
        
        // -------------- SECOND REGISTRATION FAILS
        app.buttons[loginScreen.registrationSwitchButton].tap()
        XCTAssertTrue(app.buttons[registrationScreen.registerButton].exists)
        
        nameTextField = app.textFields[registrationScreen.nameInput]
        nameTextField.tap()
        nameTextField.typeText("Test User")
        
        emailTextField = app.textFields[registrationScreen.emailInput]
        emailTextField.tap()
        email = "testuser\(uuid)@gmail.com"
        emailTextField.typeText(email)
        
        passwordSecureTextField = app.secureTextFields[registrationScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        confirmPasswordSecureTextField = app.secureTextFields[registrationScreen.confirmPasswordInput]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("password")
        
        registerButton = app.buttons[registrationScreen.registerButton]
        XCTAssertTrue(registerButton.isEnabled, "Register button should be enabled")
        app.buttons[registrationScreen.registerButton].tap()
        
        successText = app.staticTexts["Error"]
        XCTAssertTrue(successText.waitForExistence(timeout: 5), "Error should appear on screen")
        
        app.buttons[components.confirmDialogButton].tap()
        
        XCTAssertFalse(app.buttons[loginScreen.singinButton].exists)
    }
    
    @MainActor
    func test_register_user_button_disabled_at_validation_failure() throws {
        
        let registrationButton = app.buttons[registrationScreen.registerButton]
        
        app.buttons[loginScreen.registrationSwitchButton].tap()
        XCTAssertTrue(app.buttons[registrationScreen.registerButton].exists)
        
        let nameTextField = app.textFields[registrationScreen.nameInput]
        nameTextField.tap()
        nameTextField.typeText("Test User")
        
        let emailTextField = app.textFields[registrationScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("testuser@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields[registrationScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        let confirmPasswordSecureTextField = app.secureTextFields[registrationScreen.confirmPasswordInput]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("password")
        
        XCTAssertTrue(registrationButton.isEnabled, "Registration button should be enabled")
        
        //testuser@gmail.
        replaceText(emailTextField, with: "testuser@gmail.")
        XCTAssertFalse(registrationButton.isEnabled, "Registration button should not be enabled")
        
        //testusergmail.com
        replaceText(emailTextField, with: "testusergmail.com")
        XCTAssertFalse(registrationButton.isEnabled, "Registration button should not be enabled")
        
        //RESET
        replaceText(emailTextField, with: "testuser@gmail.com")
        XCTAssertTrue(registrationButton.isEnabled, "Registration button should be enabled")
        
        //non same passwords
        replaceText(confirmPasswordSecureTextField, with: "passwordnotmatch")
        XCTAssertFalse(registrationButton.isEnabled, "Registration button should not be enabled")
        
        //RESET
        replaceText(confirmPasswordSecureTextField, with: "password")
        XCTAssertTrue(registrationButton.isEnabled, "Registration button should be enabled")
        
        //name is null
        replaceText(nameTextField, with: "")
        XCTAssertFalse(registrationButton.isEnabled, "Registration button should not be enabled")
        
        replaceText(nameTextField, with: "test name")
        XCTAssertTrue(registrationButton.isEnabled, "Registration button should be enabled")
    }
    
    @MainActor
    func test_user_logs_out_and_doesnt_save_last_place() throws {
        // type email
        var emailTextField = app.textFields[loginScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.com")

        // type password
        var passwordSecureTextField = app.secureTextFields[loginScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        // tap the signin button
        app.buttons[loginScreen.singinButton].tap()
        
        // check to see signin was successful
        var methodList = app.staticTexts[methodScreen.methodTitle]
        XCTAssertTrue(methodList.waitForExistence(timeout: 5), "Method list should exist on screen")
        
        // tap the coffee navigator
        app.buttons[homeScreen.coffeeNavigationButton].tap()
        XCTAssertTrue(app.staticTexts[coffeeScreen.coffeesTitle].exists)
        
        // tap logout button
        app.buttons[homeScreen.logoutButton].tap()
        XCTAssertTrue(app.buttons[components.choiceDialogAcceptButton].exists)
        
        // accept logout
        app.buttons[components.choiceDialogAcceptButton].tap()
        XCTAssertFalse(app.staticTexts[coffeeScreen.coffeesTitle].exists)
        XCTAssertTrue(app.buttons[loginScreen.singinButton].exists)
        
        // sign in again
        emailTextField = app.textFields[loginScreen.emailInput]
        emailTextField.tap()
        emailTextField.typeText("hunter@gmail.com")

        // type password
        passwordSecureTextField = app.secureTextFields[loginScreen.passwordInput]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        // tap the signin button
        app.buttons[loginScreen.singinButton].tap()
        
        // check to see signin was successful
        methodList = app.staticTexts[methodScreen.methodTitle]
        XCTAssertTrue(methodList.waitForExistence(timeout: 5), "Method list should exist on screen")
        XCTAssertFalse(app.staticTexts[coffeeScreen.coffeesTitle].exists)
    }
    
}
