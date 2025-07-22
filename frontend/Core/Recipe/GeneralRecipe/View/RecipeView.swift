//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import SwiftUI

public struct RecipeView: View {    
    public var body: some View {
        Text("RecipeView")
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    RecipeView()
        .environmentObject(authViewModel)
}

