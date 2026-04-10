//
//  CoffeeChoiceNone.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/16/25.
//

import SwiftUI

struct CoffeeChoiceNone: View {
    var body: some View {
        PickerChoiceRow(title: "None", titleColor: .gray) {
            Image(systemName: "photo")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary.opacity(0.7))
        }
    }
}
