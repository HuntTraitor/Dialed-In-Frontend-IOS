import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @StateObject var viewModel = AuthViewModel()
    @State private var isLogoutDialogActive: Bool = false
    @State private var isLoading: Bool = true
    @Bindable private var navigator = NavigationManager.nav

    var body: some View {
        NavigationStack(path: $navigator.mainNavigator) {
            ZStack {
                if isLoading {
                    LoadingCircle()
                } else {
                    VStack {
                        MethodListView()
                            .padding(.bottom, 70)
                    }
                }
            }
            .onAppear {
                if viewModel.currentUser == nil {
                    fetchUserInfoFromToken()
                }
                isLoading = false
            }
            .addToolbar()
            .addNavigationSupport()
        }
    }
    
    private func fetchUserInfoFromToken() {
        Task {
            do {
                try await viewModel.verifyUser(withToken: keychainManager.getToken())
            } catch {
                print(error)
                keychainManager.deleteToken()
                return
            }
        }
    }
}

#Preview {
    let keychainManager = KeychainManager()
    return HomeView()
        .environmentObject(keychainManager)
}

extension View {
    func navigationBarAttributes(_ color: Color, _ font: UIFont) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: uiColor,
            .font: font
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: uiColor,
            .font: font
        ]
        return self
    }
}
