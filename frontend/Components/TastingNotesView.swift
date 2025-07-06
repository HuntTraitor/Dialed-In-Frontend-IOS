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
        VStack(alignment: .leading, spacing: 8) {
            WrappingHStack(notes, id: \.self, spacing: .constant(8), lineSpacing: 8) { note in
                Text(note.rawValue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}


