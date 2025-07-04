//
//  HelpersUITests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/4/25.
//

import XCTest

func clearText(_ textField: XCUIElement) {
    guard textField.exists else { return }
    textField.tap()
    
    // Select all (optional, if your keyboard supports it)
    // textField.press(forDuration: 1.0)
    // app.menuItems["Select All"].tap()  // sometimes available
    
    // Delete existing text by sending delete keys (adjust count as needed)
    let currentValue = textField.value as? String ?? ""
    let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
    textField.typeText(deleteString)
}
