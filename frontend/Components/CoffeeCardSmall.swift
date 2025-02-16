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
                AsyncImage(url: URL(string: coffee.imgURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, minHeight: 75, maxHeight: .infinity)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 15,
                                    bottomLeadingRadius: 15,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 0
                                )
                            )
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: 100, minHeight: 75, maxHeight: .infinity)
                    case .failure:
                        Text("Image Unavailable")
                    @unknown default:
                        EmptyView()
                        
                    }
                }
                Text(coffee.name)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(Color.black), alignment: .leading)
            }
            .frame(width: 300, height: 75)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
}

#Preview {
    CoffeeCardSmall(coffee: Coffee.MOCK_COFFEE)
}

