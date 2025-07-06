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
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
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
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Search")
}
