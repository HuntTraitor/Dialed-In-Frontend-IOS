//
//  CreateAnyRecipeRow.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/12/25.
//

import SwiftUI

struct CreateAnyRecipeRow: View {
    let curMethod: Method
    var body: some View {
        switch curMethod.type {
        case .harioSwitch:
            SwitchCreateRecipeView()
        case .v60:
            Text("V60 recipes")
        }
    }
}

#Preview {
    PreviewWrapper {
        CreateAnyRecipeRow(curMethod: Method.MOCK_METHOD)
    }
}

