//
//  CoffeeChoice.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/22/25.
//

import SwiftUI

struct CoffeeChoice: View {
    var coffee: Coffee
    
    var body: some View {
        HStack(spacing: 8) {
            ImageView(URL(string: coffee.img!))
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 1)

            Text(coffee.name)
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}


#Preview {
    CoffeeChoice(coffee: Coffee.MOCK_COFFEE)
}

