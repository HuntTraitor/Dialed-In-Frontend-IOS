//
//  Navigation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

// Define your navigation data model
enum NavigationDestination: Hashable, View {
    case home
    case coffees
    
    // return the associated view for each case
    var body: some View {
        switch self {
            case .home:
                HomeView()
            case .coffees:
                CoffeeView()
        }
    }
}
