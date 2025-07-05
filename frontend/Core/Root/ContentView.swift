//
//  ContentView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI
import SimpleKeychain

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Bindable private var navigator = NavigationManager.nav
    @State private var isLogoutDialogOpen = false
    @State private var lastValidTab = 1
    
    private let testingID = UIIdentifiers.HomeScreen.self

    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                LoginView()
            } else {
                NavigationStack(path: $navigator.mainNavigator) {
                    ZStack {
                        TabView(selection: navigator.tabHandler) {
                            HomeView()
                                .tabItem {
                                    Label("Home", systemImage: "house.fill")
                                        .accessibilityIdentifier(testingID.homeNavigationButton)
                                }
                                .tag(1)
                            
                            CoffeeView()
                                .tabItem {
                                    Label("Coffee", systemImage: "cup.and.saucer.fill")
                                        .accessibilityIdentifier(testingID.coffeeNavigationButton)
                                }
                                .tag(2)

                            Color.clear // dummy tab to trigger dialog
                                .tabItem {
                                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                                        .accessibilityIdentifier(testingID.logoutButton)
                                }
                                .tag(3)

                        }
                        .onChange(of: navigator.tabHandler.wrappedValue) { oldTab, newTab in
                            if newTab == 3 {
                                isLogoutDialogOpen = true
                                navigator.tabHandler.wrappedValue = lastValidTab
                            } else {
                                lastValidTab = newTab
                            }
                        }

                        if isLogoutDialogOpen {
                            ChoiceDialog(
                                isActive: $isLogoutDialogOpen,
                                title: "Log Out",
                                message: "Are you sure you want to log out?",
                                buttonOptions: ["Log Out", "Cancel"]
                            ) {
                                authViewModel.signOut()
                                isLogoutDialogOpen = false
                                navigator.tabHandler.wrappedValue = 1
                            }
                        }
                    }
                    .addNavigationSupport()
                    .addToolbar()
                }
            }
        }
    }
}





extension View {
    
    //addToolbar
    func addToolbar() -> some View {
        self
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text("Dialed-In")
                            .font(.custom("Cochin-BoldItalic", size: 28))
                            .foregroundColor(.black)
                            .opacity(0.75)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    //addNavigationSupport
    func addNavigationSupport() -> some View {
        self
            .navigationDestination(for: NavigationDestination.self) { destination in
            destination // The enum itself returns the view
        }
    }
}


#Preview {
    let viewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    return ContentView()
        .environmentObject(viewModel)
}
