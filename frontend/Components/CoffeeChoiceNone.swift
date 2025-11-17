//
//  CoffeeChoiceNone.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/16/25.
//

import SwiftUI

struct CoffeeChoiceNone: View {
    var body: some View {
        HStack(spacing: 8) {
            Image("No Image")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 1)
                .opacity(0.4)
            
            Text("None")
                .foregroundColor(.gray)
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}


