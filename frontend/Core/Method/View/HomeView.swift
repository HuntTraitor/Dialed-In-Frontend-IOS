import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLogoutDialogActive: Bool = false
    @State private var isLoading: Bool = true
    @Bindable private var navigator = NavigationManager.nav
    
    private let testingID = UIIdentifiers.HomeScreen.self

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
                Task {
                    if viewModel.user == nil {
                        let success = await viewModel.verifySession()
                        if !success {
                            viewModel.signOut()
                        }
                    }
                    isLoading = false
                }
            }
            .addNavigationSupport()
        }
    }
}

#Preview {
    let viewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    return HomeView()
        .environmentObject(viewModel)
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
