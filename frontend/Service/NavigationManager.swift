//
//  NavigationManager.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

// Define a singleton class for managing navigation

import SwiftUI

final class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var selectedTab = 1
    @Published var mainNavigator: [NavigationDestination] = []
    @Published var settingsNavigator: [NavigationDestination] = []
    
    var tabHandler: Binding<Int> {
        Binding(
            get: { self.selectedTab },
            set: {
                if $0 == self.selectedTab {
                    switch $0 {
                    case 1: self.mainNavigator = []
                    case 4: self.settingsNavigator = []
                    default: self.mainNavigator = []
                    }
                }
                self.selectedTab = $0
            }
        )
    }
    
    private init() {}
}

