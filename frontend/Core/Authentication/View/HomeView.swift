import SwiftUI

struct HomeView: View {
    @EnvironmentObject var keychainManager: KeychainManager
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var methodModel: MethodViewModel
    @State private var isLogoutDialogActive: Bool = false
    @State var currentUser: User? = nil
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
                if currentUser == nil {
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
        let methodModel = MethodViewModel()
        let recipeModel = RecipeViewModel()
        static let mockUser = User(id: 1, name: "Hunter Tratar", email: "hunter@example.com", createdAt: "123", activated: false)
        @State var mockCurrentUser: User? = mockUser
        
        var body: some View {
            HomeView(currentUser: mockCurrentUser)
                .environmentObject(keychainManager)
                .environmentObject(viewModel)
                .environmentObject(methodModel)
                .environmentObject(recipeModel)
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
