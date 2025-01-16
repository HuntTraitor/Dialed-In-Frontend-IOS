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
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Image(image)
                .scaleEffect(0.5)
                .frame(width: 300, height: 300)
                .opacity(0.9)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(10)
                .padding(10)
                .shadow(color: .black, radius: 2, x: 2, y: 2)
        }
        .frame(width: 294, height: 112)
        .background(Color(red: 0.997, green: 0.997, blue: 0.997))
        .cornerRadius(15)
        .shadow(radius: 5)
        .onTapGesture {
            action() // Trigger action on tap
        }
    }
}


struct MethodCardPreviews: PreviewProvider {
    static var previews: some View {
        MethodCard(title: "Pour Over", image: "v60") {
            print("hello")
        }
    }
}

