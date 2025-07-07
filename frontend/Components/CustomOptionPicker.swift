//
//  CustomOptionPicker.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/7/25.
//

import SwiftUI

struct CustomOptionPicker<Option: CustomOption>: View {
    let label: String
    @Binding var selection: Option
    @State private var customInput: String
    @State private var showMenu = false

    init(label: String, selection: Binding<Option>) {
        self.label = label
        self._selection = selection
        self._customInput = State(initialValue: selection.wrappedValue.displayName)
    }

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            TextField("Enter \(label.lowercased())", text: $customInput)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primary)
                .onChange(of: customInput) { newValue, _ in
                    selection = Option.makeCustom(newValue)
                }

            Menu {
                ForEach(Option.predefinedOptions, id: \.self) { option in
                    Button(action: {
                        selection = option
                        customInput = option.displayName
                    }) {
                        Text(option.displayName)
                        if option == selection {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                Image(systemName: "chevron.down")
                    .foregroundColor(Color("background"))
                    .padding(.leading, 8)
            }
        }

    }
}

#Preview {
    @Previewable @State var region: Region = .none
    return CustomOptionPicker(label: "Region", selection: $region)
}



