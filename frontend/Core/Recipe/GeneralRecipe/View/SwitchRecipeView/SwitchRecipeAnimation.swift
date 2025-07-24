import SwiftUI

struct SwitchRecipeAnimation: View {
    let recipe: SwitchRecipe
    var onComplete: () -> Void

    @State private var currentPhase: Int = 0
    @State private var totalWater: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 0) {
            SwitchPhaseView(recipe: recipe, phase: currentPhase, totalWater: totalWater)

            HStack {
                Image(systemName: "square.fill")
                    .foregroundColor(Color("background"))
                    .font(.system(size: 50))
                    .padding(.top, 50)
            }

            Spacer()
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
        .padding(.top, 44)
        .edgesIgnoringSafeArea(.bottom)
    }

    private func startAnimation() {
        guard currentPhase < recipe.info.phases.count else {
            onComplete()
            return
        }

        let phase = recipe.info.phases[currentPhase]
        totalWater += phase.amount

        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(phase.time), repeats: false) { _ in
            currentPhase += 1
            startAnimation()
        }
    }

    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    SwitchRecipeAnimation(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE) {
        print("Animation complete")
    }
}
