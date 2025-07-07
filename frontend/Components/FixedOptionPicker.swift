//
//  FixedOptionPicker.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/7/25.
//

import SwiftUI

struct FixedOptionPicker<Option: FixedOption>: View {
    let label: String
    @Binding var selection: Option

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()

            Menu {
                ForEach(Option.predefinedOptions, id: \.self) { option in
                    Button {
                        selection = option
                    } label: {
                        Text(option.displayName)
                        if option == selection {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selection.displayName)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("background"))
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var roastLevel: RoastLevel = .medium
    FixedOptionPicker(label: "Roast Level", selection: $roastLevel)
}
