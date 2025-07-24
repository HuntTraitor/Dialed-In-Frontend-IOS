//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import SwiftUI

public struct GeneralRecipeView: View {
    let curMethod: Method?
    
    
    public var body: some View {
        switch curMethod?.type {
        case .harioSwitch:
            SwitchRecipeListView()
        case .v60:
            Text("V60 recipes")
        default:
            AllRecipeView()
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationView {
            GeneralRecipeView(curMethod: nil)
        }
    }
}

