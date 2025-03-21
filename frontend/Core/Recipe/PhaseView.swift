import SwiftUI

struct PhaseView: View {
    let recipe: SwitchRecipe
    let phase: Int
    let totalWater: Int

    var body: some View {
        VStack {
            if let phaseData = recipe.info.phases[phase] {
                VStack {
                    Text("Step \(phase + 1) of \(recipe.info.phases.count)")
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
                // Fallback if phase data is missing
                Text("Phase \(phase + 1) not found")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    PhaseView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE, phase: 1, totalWater: 160)
}
