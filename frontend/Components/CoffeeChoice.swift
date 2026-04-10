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
        PickerChoiceRow(title: coffee.info.name) {
            if let imgString = coffee.info.img, !imgString.isEmpty, let url = URL(string: imgString) {
                ImageView(url)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    CoffeeChoice(coffee: Coffee.MOCK_COFFEE)
}
