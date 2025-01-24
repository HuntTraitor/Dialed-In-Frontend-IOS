import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLogoutDialogActive: Bool = false
    @State var currentUser: User? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TabView {
                        MethodListView()
                            .padding(.bottom, 70)
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                        
                        SettingsView()
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                    }
                }
            }
            .onAppear {
                if currentUser == nil {
                    fetchUserInfoFromToken()
                }
            }
            .navigationTitle("Dialed-In")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarAttributes(Color("background"), UIFont(name: "Cochin-BoldItalic", size: 28)!)
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

#Preview {
    struct PreviewWrapper: View {
        let keychainManager = KeychainManager()
        let viewModel = AuthViewModel()
        static let mockUser = User(id: 1, name: "Hunter Tratar", email: "hunter@example.com", createdAt: "123", activated: false)
        @State var mockCurrentUser: User? = mockUser
        
        var body: some View {
            HomeView(currentUser: mockCurrentUser)
                .environmentObject(keychainManager)
                .environmentObject(viewModel)
        }
    }
    return PreviewWrapper()
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
