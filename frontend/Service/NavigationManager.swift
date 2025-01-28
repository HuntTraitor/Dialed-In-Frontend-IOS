//
//  NavigationManager.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

// Define a singleton class for managing navigation

import SwiftUI

@Observable
final class NavigationManager {
    
    var selectedTab = 1
    
    //Tab handler for pop to root on tap of selected tab
    var tabHandler: Binding<Int> { Binding(
        get: { self.selectedTab },
        // React to taps on the tap item
        set: {
            // If the current tab selection gets tapped again
            if $0 == self.selectedTab {
                switch $0 {
                    case 1:
                        self.mainNavigator = [] //reset the navigation path
                    case 4:
                        self.settingsNavigator = []
                    default:
                        self.mainNavigator = []

                }
            }
            self.selectedTab = $0
        }
    ) }
    
    static let nav = NavigationManager() //also commonly called "shared"
    
    var mainNavigator: [NavigationDestination] = []
    var settingsNavigator: [NavigationDestination] = []
    
    private init() {}
}
