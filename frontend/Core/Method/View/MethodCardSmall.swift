//
//  MethodCardSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/12/25.
//

import SwiftUI

struct MethodCardSmall: View {
    let title: String
    let image: String

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 275, height: 100)  // Changed to match container height
                .clipShape(RoundedRectangle(cornerRadius: 15))

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
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
        .frame(width: 275, height: 75)
        .cornerRadius(15)
        .shadow(radius: 5)
        .contentShape(Rectangle())
    }
}

#Preview {
    MethodCardSmall(title: "Hario Switch", image: "Hario Switch")
}

