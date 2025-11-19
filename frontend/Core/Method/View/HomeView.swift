import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLogoutDialogActive: Bool = false
    @EnvironmentObject var navigationManager: NavigationManager

    private let testingID = UIIdentifiers.HomeScreen.self

    var body: some View {
            ZStack {
                if viewModel.isLoading {
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
                }
            }
        }
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

#Preview {
    PreviewWrapper {
        NavigationStack {
            HomeView()
        }
    }
}
