//
//  SearchBar.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/24/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(width: 16, height: 16)

            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(.black)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(height: 42)
        .padding(.horizontal, 4)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Search")
}
