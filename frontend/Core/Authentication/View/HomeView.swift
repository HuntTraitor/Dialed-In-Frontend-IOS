//
//  HomeView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/28/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    var body: some View {
        VStack {
            Text("Hello World")
            Button("logout") {
                keychainManager.deleteToken()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var keychainManager = KeychainManager()
        HomeView()
            .environmentObject(keychainManager)
    }
}
