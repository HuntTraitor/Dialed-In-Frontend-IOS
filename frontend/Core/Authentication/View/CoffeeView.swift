//
//  CoffeeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/6/25.
//

import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @Bindable private var navigator = NavigationManager.nav
    
    var body: some View {
        Text("CoffeeView")
    }
}

#Preview {
    let keychainManager = KeychainManager()
    return CoffeeView()
        .environmentObject(keychainManager)
}
