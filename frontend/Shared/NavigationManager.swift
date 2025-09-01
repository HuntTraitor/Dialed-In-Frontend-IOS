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
    @Published var homeNavigator: [NavigationDestination] = []
    @Published var coffeeNavigator: [NavigationDestination] = []
    @Published var recipesNavigator: [NavigationDestination] = []
    @Published var settingsNavigator: [NavigationDestination] = []
    
    var tabHandler: Binding<Int> {
        Binding(
            get: { self.selectedTab },
            set: {
                if $0 == self.selectedTab {
                    switch $0 {
                    case 1: self.homeNavigator = []
                    case 2: self.coffeeNavigator = []
                    case 3: self.recipesNavigator = []
                    case 4: self.settingsNavigator = []
                    default: self.homeNavigator = []
                    }
                }
                self.selectedTab = $0
            }
        )
    }
    private init() {}
}

