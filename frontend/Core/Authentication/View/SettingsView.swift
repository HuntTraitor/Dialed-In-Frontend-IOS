//
//  SettingsView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/16/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @State private var isLogoutDialogActive: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Settings")
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
            if isLoading {
                LoadingCircle()
            }
        }
    }
}

#Preview {
    let keychainManager = KeychainManager()
    return SettingsView()
        .environmentObject(keychainManager)
}
