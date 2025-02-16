//
//  CoffeeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/10/25.
//

import SwiftUI

struct CoffeeCard: View {
    let coffee: Coffee
    var body: some View {
        
        ZStack {
            VStack(spacing: 0){
                Text(coffee.name)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    .font(.custom("Italianno-Regular", size: 45))
                    .underline()
                
                AsyncImage(url: URL(string: coffee.imgURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(minHeight: 200, maxHeight: 300)
                            .padding(.bottom, 10)
                    case .empty:
                        ProgressView()
                        .frame(minHeight: 200, maxHeight: 300)
                        .padding(.bottom, 10)
                    case .failure:
                        Text("Image Unavailable")
                        .frame(minHeight: 200, maxHeight: 300)
                        .padding(.bottom, 10)
                    @unknown default:
                        EmptyView()
                    }
                }

                HStack(spacing: 0) {
                    Text(coffee.region)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.subheadline)
                        .border(Color.black)
                    Text(coffee.process)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.subheadline)
                        .border(Color.black)
                }
                .border(Color.black)
                
                Text(coffee.description)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                    .padding()
                
                
                
                Spacer()
            }
            .frame(width: 350, height: 500)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
}


#Preview {
    CoffeeCard(
        coffee: Coffee.MOCK_COFFEE
    )
}
