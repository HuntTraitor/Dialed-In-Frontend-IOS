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
                            .frame(minHeight: 75, maxHeight: .infinity)
                    case .empty, .failure:
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
    CoffeeCardSmall(title: "Milky Cake", imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png")
}

