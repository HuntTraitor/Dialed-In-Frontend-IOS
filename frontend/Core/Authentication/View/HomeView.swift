//
//  HomeView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/28/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @State private var isLogoutDialogActive: Bool = false
    var body: some View {
        ZStack {
            VStack {
                Text("Hello World")
                Button("logout") {
                    isLogoutDialogActive = true
                }
            }
            if isLogoutDialogActive {
                CustomDialog(
                    isActive: $isLogoutDialogActive,
                    title: "Success",
                    message: "You have been successfully logged out",
                    buttonTitle: "Close",
                    action: {
                        isLogoutDialogActive = false
                        keychainManager.deleteToken()
                    }
                )
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
