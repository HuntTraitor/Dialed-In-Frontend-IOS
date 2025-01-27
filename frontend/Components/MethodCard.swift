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
        GeometryReader { geometry in
                AsyncImage(url: URL(string: image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 300, height: 200)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(15)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    case .failure:
                        Color.red
                            .frame(width: 300, height: 200)
                            .cornerRadius(15)
                    @unknown default:
                        EmptyView()
                    }
                }

                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                    .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)

        }
        .frame(width: 300, height: 200)
        .cornerRadius(15)
        .shadow(radius: 5)
        .contentShape( Rectangle())
        .onTapGesture {
            action()
        }
    }


}


struct MethodCardPreviews: PreviewProvider {
    static var previews: some View {
        MethodCard(title: "Pour Over", image: "https://www.hario-canada.ca/cdn/shop/products/hario_ssd-200-b-v60-02-switch-immersion-dripper_pouring_1024x1024.jpg?v=1672852353") {
            print("hello")
        }
    }
}

