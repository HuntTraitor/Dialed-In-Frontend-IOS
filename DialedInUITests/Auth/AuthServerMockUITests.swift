//
//  AuthServerMockUITests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/4/25.
//
import XCTest
import Swifter

final class AuthServerMockUITests: XCTestCase {
    
    var app: XCUIApplication!
    var server: HttpServer!
    
    let loginScreen = UIIdentifiers.LoginScreen.self
    let registrationScreen = UIIdentifiers.RegistrationScreen.self
    let homeScreen = UIIdentifiers.HomeScreen.self
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        server = HttpServer()
        
        server["/tokens/authentication"] = { _ in
            let json: [String: Any] = [
                "authentication_token": [
                    "token": "KCU6T25KEZKWODKWSOH5PI3TFE",
                    "expiry": "2025-07-19T09:40:45.553347004Z"
                ]
            ]
            return .ok(.json(json))
        }
        
        server["users/verify"] = { _ in
            let json: [String: Any] = [
                "user": [
                    "id": 1,
                    "created_at": "2025-07-04T19:20:22Z",
                    "name": "Hunter",
                    "email": "hunter@gmail.com",
                    "activated": false
                ]
            ]
            return .ok(.json(json))
        }

        try server.start(8080, forceIPv4: true)
        app = XCUIApplication()
        app.launchArguments.append("--reset-keychain")
        app.launchArguments.append(contentsOf: ["-UITest", "no-animations"])
        app.launchEnvironment["-base-url"] = "http://localhost:8080/"
        app.launch()
    }

    override func tearDownWithError() throws {
        server.stop()
        app = nil
    }
    
    @MainActor
    func test_sign_in_route_failure() throws {
        
        server["/tokens/authentication"] = { _ in
            return .internalServerError
        }
        
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
        
        let errorDialog = app.buttons[loginScreen.errorDialogButton]
        XCTAssertTrue(errorDialog.waitForExistence(timeout: 5), "An error should appear on screen")
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        let found = allStaticTexts.contains { element in
            element.label.contains("500")
        }
        XCTAssertTrue(found, "Expected substring not found in any static text")
    }
    
    @MainActor
    func test_verify_user_route_failure() throws {
        
        server["users/verify"] = { _ in
            return .internalServerError
        }
        
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
        
        let errorDialog = app.buttons[loginScreen.errorDialogButton]
        XCTAssertTrue(errorDialog.waitForExistence(timeout: 5), "An error should appear on screen")
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        let found = allStaticTexts.contains { element in
            element.label.contains("500")
        }
        XCTAssertTrue(found, "Expected substring not found in any static text")
    }
}


