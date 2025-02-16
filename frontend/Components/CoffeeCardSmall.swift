//
//  CoffeeCardSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/15/25.
//

import SwiftUI

struct CoffeeCardSmall: View {
    let title: String
    let imgURL: String
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: imgURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, minHeight: 75, maxHeight: .infinity)
                    case .empty:
                        LoadingCircle()
                            .frame(maxWidth: 100, minHeight: 75, maxHeight: .infinity)
                    case .failure:
                        Text("Image Unavailable")
                    @unknown default:
                        EmptyView()
                        
                    }
                }
                Text(title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(Color.black)
            }
            .frame(width: 300, height: 75)
            .border(Color.black)
        }
    }
}

#Preview {
    CoffeeCardSmall(title: "Milky Cake", imgURL: "https://www.lankerpack.com/wp-content/uploads/2023/04/matte-coffee-bag-mockup-template.png")
}

