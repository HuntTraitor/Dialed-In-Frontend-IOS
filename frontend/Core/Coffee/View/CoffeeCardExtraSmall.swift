//
//  CoffeeCardExtraSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/6/25.
//

import SwiftUI

struct CoffeeCardExtraSmall: View {
    var coffee: Coffee
    var body: some View {
        HStack {
            Text(coffee.info.name)
                .padding(.leading, 30)
                .lineLimit(1)
            Spacer()
            StarRatingView(rating: coffee.info.rating?.rawValue ?? .zero)
                .padding(.trailing, 30)
        }
    }
}

#Preview {
    CoffeeCardExtraSmall(coffee: Coffee.MOCK_COFFEE)
}

