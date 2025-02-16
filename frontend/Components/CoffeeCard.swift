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
    let process: String
    let description: String
    let imgURL: String

    var body: some View {
        
        ZStack {
            VStack(spacing: 0){
                Text(name)
                    .frame(maxWidth: .infinity)
                    .padding([.bottom, .top], 40)
                    .font(.title2)
                    .border(Color.black)
                
                AsyncImage(url: URL(string: imgURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 200, maxHeight: 300)
                    case .empty:
                        ProgressView()
                        .frame(minHeight: 200, maxHeight: 300)
                    case .failure:
                        Text("Image Unavailable")
                        .frame(minHeight: 200, maxHeight: 300)
                    @unknown default:
                        EmptyView()
                        
                    }
                }

                HStack(spacing: 0) {
                    Text(region)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.subheadline)
                        .border(Color.black)
                    Text(process)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.subheadline)
                        .border(Color.black)
                }
                .border(Color.black)
                
                Text(description)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                    .padding()
                
                
                
                Spacer()
            }
            .frame(width: 350, height: 500)
            .border(Color.black)
        }
    }
}


#Preview {
    CoffeeCard(
        name: "Milky Cake",
        region: "Colombia",
        process: "Thermal Shock",
        description: "This is a delicious sweet coffee that has notes of caramel and chocolate.",
        imgURL: "https://st.kofio.co/img_product/boeV9yxzHn2OwWv/9628/sq_350_MFbecow28XW0zprTGaVA_102573.png"
    )
}
