//
//  MethodCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodCard: View {
    let title: String
    let image: String

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 175)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .clipped()

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .shadow(color: .black, radius: 2, x: 2, y: 2)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.trailing, 10)
                        .padding(.bottom, 20)
                }
            }
        }
        .frame(width: 300, height: 200)
        .cornerRadius(15)
        .shadow(radius: 5)
        .contentShape(Rectangle())
    }
}





struct MethodCardPreviews: PreviewProvider {
    static var previews: some View {
        MethodCard(title: "Hario Switch", image: "Hario Switch")
    }
}

