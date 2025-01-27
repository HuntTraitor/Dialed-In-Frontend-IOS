//
//  RecipeListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/27/25.
//

import SwiftUI

struct RecipeListView: View {
    let curMethod: Method
    var body: some View {
        Text("List of recipes for \(curMethod.name)")
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(curMethod: Method(id: 1, name: "Pour Over", img: "123"))
    }
}
