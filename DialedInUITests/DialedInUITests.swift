//
//  DialedInUITests.swift
//  DialedInUITests
//
//  Created by Hunter Tratar on 1/3/25.
//

import XCTest

final class DialedInUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        
        let app = XCUIApplication()
        // expect there to be email address and password on screen
        // expect there not to be name or confirm password
        app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Dont have an account?, Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // expect there to be name, email, password, confirm password on screen
        app/*@START_MENU_TOKEN@*/.staticTexts["Sign in"]/*[[".buttons[\"Already have an account?, Sign in\"].staticTexts[\"Sign in\"]",".staticTexts[\"Sign in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // same as last one
        
    }
    
}
