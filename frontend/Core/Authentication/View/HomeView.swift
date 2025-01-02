//
//  HomeView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/28/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLogoutDialogActive: Bool = false
    @State private var currentUser: User? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                if let user = currentUser {
                    Text("Welcome \(user.name)")
                }
                Button("logout") {
                    // TODO create a dialog for "are u sure"
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
        .onAppear {
            if currentUser == nil {
                fetchUserInfoFromToken()
            }
        }
    }
    
    private func fetchUserInfoFromToken() {
        Task {
            let result: VerifyUserResult
            do {
                result = try await viewModel.verifyUser(withToken: keychainManager.getToken())
            } catch {
                print(error)
                return
            }
            
            switch result {
            case .user(let user):
                currentUser = user
            case .error:
                keychainManager.deleteToken()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let keychainManager = KeychainManager()
        keychainManager.saveToken("RCEWHVFEI6KVUYM2JYVUXKUPG4")

        let viewModel = AuthViewModel()

        return HomeView()
            .environmentObject(keychainManager)
            .environmentObject(viewModel)
    }
}

