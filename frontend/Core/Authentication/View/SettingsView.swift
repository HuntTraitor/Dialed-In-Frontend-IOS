//
//  SettingsView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/16/25.
//

import SwiftUI

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLogoutDialogActive: Bool = false
    @State private var isLoading: Bool = false
    @Bindable private var navigator = NavigationManager.nav
    
    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            ZStack {
                VStack {
                    Text("Settings")
                    
                    Button("Logout") {
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
                            isLoading = true
                            Task {
                                viewModel.signOut()
                                isLoading = false
                            }
                        }
                    )
                }
                
                if isLoading {
                    LoadingCircle()
                }
            }
            .addToolbar()
            .addNavigationSupport()
        }
    }
}


#Preview {
    let viewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    return SettingsView()
        .environmentObject(viewModel)
}
