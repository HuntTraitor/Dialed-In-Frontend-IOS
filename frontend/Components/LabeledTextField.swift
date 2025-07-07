//
//  LabeledTextField.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/7/25.
//

import SwiftUI

struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = "Add value"

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primary)
        }
    }
}
