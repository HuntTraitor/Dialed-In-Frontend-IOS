import SwiftUI

struct SwitchPhaseView: View {
    let recipe: SwitchRecipe
    let phase: Int
    let totalWater: Int

    var phaseData: SwitchRecipe.RecipeInfo.Phase? {
        recipe.info.phases.indices.contains(phase) ? recipe.info.phases[phase] : nil
    }

    var body: some View {
        VStack {
            if let phaseData = phaseData {
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
                    .id("phase-\(phase)")
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
                Text("Phase \(phase + 1) not found")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    SwitchPhaseView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE, phase: 1, totalWater: 160)
}
