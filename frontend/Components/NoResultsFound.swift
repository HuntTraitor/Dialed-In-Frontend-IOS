//
//  NoResultsFound.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/2/25.
//

import SwiftUI

struct NoResultsFound: View {
    var itemName: String
    var systemImage: String

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.gray)
                .opacity(0.3)

            Text("Your \(itemName)s are currently empty!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
                .frame(maxWidth: 400)

            Text("Tap the button above to add your first \(itemName).")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)
                .padding(.horizontal, 50)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}





#Preview {
    NoResultsFound(itemName: "coffee", systemImage: "cup.and.heat.waves")
}

