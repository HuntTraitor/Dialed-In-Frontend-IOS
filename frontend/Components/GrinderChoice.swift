//
//  GrinderChoice.swift
//  DialedIn
//
//  Created by Hunter Tratar on 4/9/26.
//

import SwiftUI

struct GrinderChoice: View {
    let grinder: Grinder

    var body: some View {
        PickerChoiceRow(title: grinder.name) {
            Image("coffee.grinder")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 24)
        }
    }
}

struct GrinderChoiceNone: View {
    var body: some View {
        PickerChoiceRow(title: "None", titleColor: .gray) {
            Image(systemName: "photo")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary.opacity(0.7))
        }
    }
}
