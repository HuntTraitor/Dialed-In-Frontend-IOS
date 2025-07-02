//
//  CoffeeCardSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/15/25.
//

import SwiftUI

struct CoffeeCardSmall: View {
    let coffee: Coffee
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack {
                    ImageView(URL(string: coffee.img!))
                }
                .frame(maxWidth: 100, minHeight: 75, maxHeight: .infinity)
                .padding(.leading, 10)
                .clipShape(
                    .rect(
                        topLeadingRadius: 15,
                        bottomLeadingRadius: 15,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    )
                )
                Text(coffee.name)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(systemName: "arrow.right")
                    .foregroundColor(Color("background"))
                    .padding()
                    .padding(.trailing, 10)
            }
            .frame(height: 75)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
    }
}

#Preview {
    CoffeeCardSmall(coffee: Coffee.MOCK_COFFEE)
}

