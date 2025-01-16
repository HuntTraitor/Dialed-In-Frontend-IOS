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
                setupNavigationBarAppearance()
                if currentUser == nil {
                    fetchUserInfoFromToken()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Hello, \(currentUser?.name ?? "")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5) // Adjusts the title's position for a smaller navbar
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        // Set up the navigation bar background appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Convert SwiftUI Color to UIColor
        appearance.backgroundColor = UIColor(Color("background"))
        
        // Adjust the title text color and font size for a smaller look
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold) // Shrinks the title font size
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold) // Shrinks large title font size
        ]
        
        // Apply the appearance to different bar states
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Remove any background image to make the bar appear more compact
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
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
