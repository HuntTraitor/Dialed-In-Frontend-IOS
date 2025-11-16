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
    @State private var searchText: String = ""

    private var groupedNotes: [String: [TastingNote]] {
        let filtered = TastingNote.allCases.filter { note in
            searchText.isEmpty ||
            note.displayName.localizedCaseInsensitiveContains(searchText)
        }

        return Dictionary(grouping: filtered, by: \.category)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                VStack {
                    SearchBar(text: $searchText, placeholder: "Search Tasting Notes")
                        .padding(.horizontal, 1)
                        .padding(.vertical, 1)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                ForEach(groupedNotes.keys.sorted(), id: \.self) { category in
                    if let notes = groupedNotes[category], !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category)
                                .font(.headline)

                            WrappingHStack(notes, id: \.self, spacing: .constant(8), lineSpacing: 8) { note in
                                Text(note.displayName)
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

