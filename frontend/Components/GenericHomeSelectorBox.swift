//
//  GenericHomeSelectorBox.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/21/25.
//

import SwiftUI

struct GenericHomeSelectorBox: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {

            ZStack {
                Circle()
                    .fill(Color("background"))
                    .opacity(0.7)
                    .shadow(
                        color: Color.black.opacity(0.10),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                    .frame(width: 70, height: 70)

                Image(systemName: icon)
                    .font(.system(size: 30))
                
            }

            Text(title)
                .font(.footnote)
                .foregroundColor(.black.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}






#Preview {
    GenericHomeSelectorBox(title: "Common Recipes", icon: "cup.and.saucer")
}
