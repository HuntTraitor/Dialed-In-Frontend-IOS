//
//  CoffeeCardSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/15/25.
//

import SwiftUI

struct CoffeeCardSmall: View {
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text("Image")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(width: 100, height: 75)
                    .border(Color.black)
                Text("Title")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(Color.black)
            }
            .frame(width: 300, height: 75)
            .border(Color.black)
        }
    }
}

#Preview {
    CoffeeCardSmall()
}

