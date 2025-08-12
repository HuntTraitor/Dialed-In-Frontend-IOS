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
            if let imgString = coffee.info.img, !imgString.isEmpty, let url = URL(string: imgString) {
                ImageView(url)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .shadow(radius: 1)
            } else {
                Image("No Image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            Text(coffee.info.name)
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

