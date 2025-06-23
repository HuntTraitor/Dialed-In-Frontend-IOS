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
        HStack() {
            ImageView(URL(string: coffee.img!))
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2)
            
            Text(coffee.name)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        
    }
}

#Preview {
    CoffeeChoice(coffee: Coffee.MOCK_COFFEE)
}

