//
//  TastingNotesView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/6/25.
//

import SwiftUI
import WrappingHStack

struct TastingNotesView: View {
    let notes: [TastingNote]

    var body: some View {
        VStack {
            WrappingHStack(notes, id: \.self, alignment: .leading, spacing: .dynamicIncludingBorders(minSpacing: 8), lineSpacing: 8) { note in
                Text(note.displayName)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    TastingNotesView(notes: [.apple, .cherry, .peach, .allspice, .almond, .applePieSpice, .blueberry, .banana])
}


