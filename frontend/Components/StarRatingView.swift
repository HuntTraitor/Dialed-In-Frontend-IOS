//
//  StarRatingView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/5/25.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Int // 0 to 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(index <= rating ? Color("background") : .gray)
            }
        }
    }
}

#Preview {
    StarRatingView(rating: 4)
}
