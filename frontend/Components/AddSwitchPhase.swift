//
//  AddSwitchPhase.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/24/25.
//

import SwiftUI

struct PhaseRowView: View {
    @Binding var phaseNum: Int
    @Binding var phase: SwitchRecipeInput.RecipeInfo.Phase

    var body: some View {
        VStack(spacing: 12) {
            Text("Pour \(phaseNum)")
                .italic()
                .underline()

            HStack(spacing: 10) {
                Button(action: {
                    phase.open = true
                }) {
                    Text("Open")
                        .foregroundColor(phase.open ? .white : .primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(phase.open ? Color("background") : Color.gray.opacity(0.2))
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    phase.open = false
                }) {
                    Text("Closed")
                        .foregroundColor(!phase.open ? .white : .primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(!phase.open ? Color("background") : Color.gray.opacity(0.2))
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
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
        @State var mockPhase = SwitchRecipeInput.RecipeInfo.Phase(open: true, time: 30, amount: 150)
        @State var phaseNum = 1

        var body: some View {
            VStack {
                PhaseRowView(phaseNum: $phaseNum, phase: $mockPhase)
            }
        }
    }

    return PreviewContainer()
}

