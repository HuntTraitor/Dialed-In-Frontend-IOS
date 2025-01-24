import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLogoutDialogActive: Bool = false
    @State var currentUser: User? = nil
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    LoadingCircle()
                } else {
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
            }
            .onAppear {
                if currentUser == nil {
                    fetchUserInfoFromToken()
                }
                isLoading = false
            }
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
    }
    
    private func fetchUserInfoFromToken() {
        Task {
            let result: VerifyUserResult
            do {
                result = try await viewModel.verifyUser(withToken: keychainManager.getToken())
            } catch {
                print(error)
                keychainManager.deleteToken()
                return
            }
        
            switch result {
            case .user(let user):
                currentUser = user
            default:
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
