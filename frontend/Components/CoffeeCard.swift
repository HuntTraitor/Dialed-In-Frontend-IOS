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
        
        ZStack {
            VStack(spacing: 0){
                Text("Title")
                    .frame(maxWidth: .infinity)
                    .padding([.bottom, .top], 40)
                    .border(Color.black)
                
                
                Text("Image")
                    .frame(maxWidth: .infinity)
                    .padding([.bottom, .top], 80)
                    .border(Color.black)
                    

                HStack(spacing: 0) {
                    Text("Region")
                        .padding(.leading, 30)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .border(Color.black)
                    Text("Process")
                        .padding(.trailing, 30)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .border(Color.black)
                }
                .border(Color.black)
                
                Text("Description (Flavor notes, etc.)")
                    .padding([.top, .bottom], 55)
                
                Spacer()
            }
            .frame(width: 350, height: 500)
            .border(Color.black)
        }
        
        
//        ZStack {
//            VStack(spacing: 10) {
//                Text(name)
//                    .font(Font.custom("Italianno-Regular", size: 30))
//                    .padding(.top, 10)
//
//                HStack {
//                    AsyncImage(url: URL(string: imgURL)) { phase in
//                        switch phase {
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 100, height: 100)
//                                .clipped()
//                                .cornerRadius(10) // ✅ Keeps rounded edges
//                        case .empty, .failure:
//                            Color.gray.opacity(0.3)
//                                .frame(width: 100, height: 100)
//                                .cornerRadius(10)
//                        @unknown default:
//                            EmptyView()
//                        }
//                    }
//                    .frame(width: 70, height: 70)
////                    .padding()
//
////                    VStack(alignment: .leading, spacing: 5) {
////                        Text(region)
////                            .font(Font.custom("Italianno-Regular", size: 23))
////                        Text(description)
////                            .font(Font.custom("HinaMincho-Regular", size: 15))
////                            .padding(.bottom, 10)
////                    }
////                    .padding(.trailing, 10)
//                }
//            }
//        }
//        .frame(width: 150, height: 150)
//        .background(RoundedRectangle(cornerRadius: 20).fill(Color("background")))
//        .opacity(0.95)
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
