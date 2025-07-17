//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import SwiftUI

public struct RecipeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: SwitchRecipeViewModel<DefaultSwitchRecipeService>
    
    init() {
        let service = DefaultSwitchRecipeService(baseURL: EnvironmentManager.current.baseURL)
        _viewModel = StateObject(wrappedValue: SwitchRecipeViewModel<DefaultSwitchRecipeService>(recipeService: service))
    }
    
    
    public var body: some View {
        Text("RecipeView")
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    RecipeView()
        .environmentObject(authViewModel)
}

