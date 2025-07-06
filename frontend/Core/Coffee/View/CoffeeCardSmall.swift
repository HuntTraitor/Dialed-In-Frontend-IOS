//
//  CoffeeCardSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/15/25.
//

import SwiftUI

struct CoffeeCardSmall: View {
    let coffee: Coffee
    var body: some View {
        VStack {
            HStack {
                Text(coffee.name)
                    .padding(.leading, 50)
                Spacer()
                StarRatingView(rating: coffee.rating?.rawValue ?? 0)
                    .padding(.trailing, 50)
            }
            Divider()
                .frame(height: 1)
                .background(Color("background"))
                .padding(.horizontal, 20)
            
            HStack(alignment: .top, spacing: 16) {
                // Image on the left
                if let imgString = coffee.img, !imgString.isEmpty, let url = URL(string: imgString) {
                    ImageView(url)
                        .frame(width: 100, height: 100)
                } else {
                    Color.clear
                        .frame(width: 50, height: 100)
                }
                
                // First column of text
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(title: "Roaster", value: coffee.roaster ?? "-")
                    InfoRow(title: "Process", value: coffee.process ?? "-")
                    InfoRow(title: "Roast Level", value: coffee.roastLevel?.rawValue ?? "-")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Second column of text
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(title: "Roast Type", value: coffee.originType?.rawValue ?? "-")
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Decaff?")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if coffee.decaf == true {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color("background"))
                                .font(.title2)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.title2)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Tasting Notes")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text((coffee.tastingNotes?.map { $0.rawValue }.joined(separator: ", ")) ?? "-")
                            .font(.system(size: 13))
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
        }
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 13))
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    CoffeeCardSmall(coffee: Coffee.MOCK_COFFEE)
}

