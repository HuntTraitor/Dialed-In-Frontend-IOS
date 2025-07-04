//
//  HelpersUITests.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/4/25.
//

import XCTest

func replaceText(_ textField: XCUIElement, with newText: String) {
    guard textField.exists else { return }
    textField.tap()

    // Get the current text
    let currentValue = textField.value as? String ?? ""
    
    // Send delete keys to remove it
    let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
    textField.typeText(deleteString)
    
    // Type the new text
    textField.typeText(newText)
}
