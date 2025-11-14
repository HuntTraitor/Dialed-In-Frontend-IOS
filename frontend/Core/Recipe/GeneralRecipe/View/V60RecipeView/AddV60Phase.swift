//
//  AddV60Phase.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI

struct AddV60Phase: View {
    @Binding var phaseNum: Int
    @Binding var phase: V60Phase

    var body: some View {
        VStack(spacing: 12) {
            Text("Pour \(phaseNum)")
                .italic()
                .underline()

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
        @State var mockPhase = V60Phase(time: 30, amount: 150)
        @State var phaseNum = 1

        var body: some View {
            VStack {
                AddV60Phase(phaseNum: $phaseNum, phase: $mockPhase)
            }
        }
    }

    return PreviewContainer()
}

