//
//  CoffeeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/10/25.
//

import SwiftUI

struct CoffeeCard: View {
    let name: String
    let region: String
    let description: String
    let imgURL: String
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        Text(name)
                            .font(Font.custom("Italianno-Regular", size: 40))
                            .padding(.top, 20)
                        HStack {
                            AsyncImage(url: URL(string: imgURL)){ phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                case .empty, .failure:
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding()
                            VStack {
                                Text(region)
                                    .font(Font.custom("Italianno-Regular", size: 35))
                                Text(description)
                                    .font(Font.custom("HinaMincho-Regular", size: 18))
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 20).fill(Color("background")))
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.4)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .opacity(0.95)
        }
    }
}

#Preview {
    CoffeeCard(
        name: "Milky Cake",
        region: "Colombia",
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
    )
}
