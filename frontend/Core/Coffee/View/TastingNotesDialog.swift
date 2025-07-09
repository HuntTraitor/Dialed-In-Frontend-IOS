//
//  TastingNotesDialog.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/9/25.
//

import SwiftUI
import WrappingHStack

struct TastingNotesDialog: View {
    @Binding var selectedTastingNotes: [TastingNote]

    private var groupedNotes: [String: [TastingNote]] {
        Dictionary(grouping: TastingNote.allCases, by: \.category)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(groupedNotes.keys.sorted(), id: \.self) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category)
                            .font(.headline)

                        WrappingHStack(groupedNotes[category] ?? [], id: \.self, spacing: .constant(8), lineSpacing: 8) { note in
                            Text(note.rawValue.capitalized)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(selectedTastingNotes.contains(note) ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .font(.caption)
                                .onTapGesture {
                                    toggle(note)
                                }
                        }
                    }
                    Divider()
                }
            }
            .padding()
        }
        .navigationTitle("Tasting Notes")
    }

    private func toggle(_ note: TastingNote) {
        if let index = selectedTastingNotes.firstIndex(of: note) {
            selectedTastingNotes.remove(at: index)
        } else {
            selectedTastingNotes.append(note)
        }
    }
}



#Preview {
    @Previewable @State var selectedTastingNotes: [TastingNote] = []
    return TastingNotesDialog(selectedTastingNotes: $selectedTastingNotes)
}

