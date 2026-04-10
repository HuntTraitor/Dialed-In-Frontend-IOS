//
//  PickerChoiceRow.swift
//  DialedIn
//
//  Created by Hunter Tratar on 4/9/26.
//

import SwiftUI

struct PickerChoiceRow<Leading: View>: View {
    let title: String
    var titleColor: Color = .primary
    var iconBackground: Color = Color(.secondarySystemBackground)
    @ViewBuilder let leading: () -> Leading

    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(iconBackground)
                .overlay {
                    leading()
                }
                .frame(width: 32, height: 32, alignment: .center)

            Text(title)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(titleColor)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: 42, alignment: .center)
        .padding(.horizontal, 4)
    }
}
