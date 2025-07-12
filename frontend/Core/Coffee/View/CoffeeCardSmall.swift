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
                Text(coffee.info.name)
                    .padding(.leading, 30)
                    .lineLimit(1)
                Spacer()
                StarRatingView(rating: coffee.info.rating?.rawValue ?? .zero)
                    .padding(.trailing, 30)
            }
            Divider()
                .frame(height: 1)
                .background(Color("background"))
                .padding(.horizontal, 20)
            
            HStack(alignment: .top, spacing: 16) {
                // Image on the left
                if let imgString = coffee.info.img, !imgString.isEmpty, let url = URL(string: imgString) {
                    ImageView(url)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 20)
                } else {
                    Color.clear
                        .frame(width: 50, height: 100)
                }
                
                // First column of text
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(title: "Roaster", value: (coffee.info.roaster?.isEmpty == false && coffee.info.roaster?.lowercased() != "unknown") ? coffee.info.roaster! : "-")
                    InfoRow(title: "Region", value: (coffee.info.region?.isEmpty == false && coffee.info.region?.lowercased() != "unknown") ? coffee.info.region! : "-")
                    InfoRow(title: "Process", value: (coffee.info.process?.isEmpty == false && coffee.info.process?.lowercased() != "unknown") ? coffee.info.process! : "-")

                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Second column of text
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(
                        title: "Roast Level",
                        value: (coffee.info.roastLevel != .unknown) ? coffee.info.roastLevel?.displayName ?? "-" : "-"
                    )

                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Decaff?")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if coffee.info.decaf == true {
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

                        Text((coffee.info.tastingNotes?.map { $0.rawValue }.joined(separator: ", ")) ?? "-")
                            .font(.system(size: 13))
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
        }
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
    CoffeeCardSmall(coffee: Coffee.MOCK_NOTHING_COFFEE)
}

