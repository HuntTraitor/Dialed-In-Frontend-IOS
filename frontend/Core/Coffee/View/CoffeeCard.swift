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
                VStack {
                    ImageView(URL(string: coffee.img))
                }
                .frame(minHeight: 200, maxHeight: 300)
                .padding(.bottom, 10)

                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("Region")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.leading, 4)
                            .padding(.top, 4)
                            .italic()
                        
                        Text(coffee.region)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.system(size: 12))
                            .offset(y: -8)
                        
                    }
                    .border(Color.black)

                    VStack(spacing: 0) {
                        Text("Process")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.leading, 4)
                            .padding(.top, 4)
                            .italic()
                        Text(coffee.process)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.system(size: 12))
                            .offset(y: -8)
                    }
                    .border(Color.black)
                }
                
                ZStack(alignment: .topLeading) {
                    Text("Description")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(4)
                        .italic()
                    Text(coffee.description)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                        .padding()
                        .padding(.top, 10)
                }
                
                
                
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
