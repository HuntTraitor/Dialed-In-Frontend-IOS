//
//  AddSwitchPhase.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/24/25.
//

import SwiftUI

struct PhaseRowView: View {
    @Binding var phaseNum: Int
    @Binding var phase: SwitchRecipe.RecipeInfo.Phase

    var body: some View {
        VStack(spacing: 0) {
            Text("Pour \(phaseNum)")
                .italic()
                .underline()
            Toggle("Open", isOn: $phase.open)
                .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("Time (seconds)")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("e.g. 30", value: $phase.time, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading) {
                Text("Amount (ml)")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("e.g. 150", value: $phase.amount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
    }
}


#Preview {
    struct PreviewContainer: View {
        @State var mockPhase = SwitchRecipe.RecipeInfo.Phase(open: true, time: 30, amount: 150)
        @State var phaseNum = 1

        var body: some View {
            Form {
                Section {
                    PhaseRowView(phaseNum: $phaseNum, phase: $mockPhase)
                }
            }
        }
    }

    return PreviewContainer()
}

