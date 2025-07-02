//
//  NoResultsFound.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/2/25.
//

import SwiftUI

struct NoSearchResultsFound: View {
    var itemName: String

    var body: some View {
        VStack {
            Spacer()
            Image("NoResults")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(0.25)
            Text("Looks like we can't find any \(itemName) matching your search")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(50)
                .frame(maxWidth: 400)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



#Preview {
    NoSearchResultsFound(itemName: "coffee")
}

