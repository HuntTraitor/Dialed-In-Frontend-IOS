//
//  PhaseView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/17/25.
//

import SwiftUI

struct PhaseView: View {
    let recipe: SwitchRecipe
    let phase: Int
    
    var totalWater: Int {
        recipe.info.phases.values.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack {
            if let phaseData = recipe.info.phases[phase] {
                VStack {
                    Text("Step \(phase) of \(recipe.info.phases.count)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Divider()
                }
                .padding(.top, 50)
                Text(phaseData.open ? "OPEN" : "CLOSED")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 25)
                CountdownTimer(seconds: phaseData.time)
                    .padding()
                VStack {
                    Text("Pour \(phaseData.amount)g")
                        .font(.title2)
                        .bold()
                    Text("Total water: \(totalWater)g")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
            } else {
                Text("Phase not found")
            }
        }
    }
}


#Preview {
    PhaseView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE, phase: 1)
}

