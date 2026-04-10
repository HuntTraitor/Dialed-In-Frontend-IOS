//
//  V60Animation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI
import Combine

struct V60Animation: View {
    let recipe: BaseRecipe<V60Info>
    @Binding var showAnimation: Bool

    @State private var currentPhaseIndex: Int = 0
    @State private var startDate: Date?
    @State private var timer: AnyCancellable?

    @State private var showStopConfirmation = false

    private var phases: [V60Phase] {
        recipe.info.phases
    }

    private var cumulativePhaseEndTimes: [TimeInterval] {
        var total: TimeInterval = 0
        return phases.map { phase in
            total += TimeInterval(phase.time)
            return total
        }
    }

    private var phaseStartTimes: [TimeInterval] {
        var total: TimeInterval = 0
        return phases.map { phase in
            let start = total
            total += TimeInterval(phase.time)
            return start
        }
    }

    private var trackerSteps: [RecipeAnimationStep] {
        phases.enumerated().map { index, phase in
            RecipeAnimationStep(
                id: index,
                title: trackerTitle(for: index, phase: phase),
                detailText: trackerDetailText(amount: phase.amount, endTime: Int(cumulativePhaseEndTimes[index]))
            )
        }
    }

    private func trackerHeight(for availableHeight: CGFloat) -> CGFloat {
        let preferred = min(CGFloat(trackerSteps.count) * 68, 220)
        return min(preferred, max(140, availableHeight * 0.34))
    }

    private func bottomSectionHeight(for availableHeight: CGFloat) -> CGFloat {
        let trackerArea = trackerHeight(for: availableHeight)
        let controlBand = max(96, availableHeight * 0.18)
        return trackerArea + controlBand
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            if currentPhaseIndex < recipe.info.phases.count {
                let cumulativeAmount = recipe.info.phases
                    .prefix(currentPhaseIndex + 1)
                    .reduce(0) { partial, phase in
                        partial + phase.amount
                    }
                let trackerHeight = trackerHeight(for: geometry.size.height)
                let bottomSectionHeight = bottomSectionHeight(for: geometry.size.height)

                VStack(spacing: 0) {
                    VStack(spacing: 22) {
                        // Phase progress bar
                        HStack(spacing: 8) {
                            ForEach(0..<recipe.info.phases.count, id: \.self) { index in
                                Rectangle()
                                    .fill(index <= currentPhaseIndex ?
                                          brownShade(for: index, total: recipe.info.phases.count) :
                                          Color.gray.opacity(0.3))
                                    .frame(height: 6)
                                    .cornerRadius(3)
                            }
                        }
                        .padding(.horizontal)

                        VStack(spacing: 24) {
                            Text("Phase \(currentPhaseIndex + 1)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pour to \(cumulativeAmount)g")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.horizontal, 60)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("background").opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color("background").opacity(0.1))
                                    )
                            )
                        }

                        V60Pour(fillIn: Double(phases[currentPhaseIndex].time))
                            .id(currentPhaseIndex)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 8)

                    VStack(spacing: 0) {
                        Spacer(minLength: 0)

                        HStack(spacing: 40) {
                            Button(action: {
                                skipBack()
                            }) {
                                Image(systemName: "arrowshape.backward.fill")
                                    .font(.system(size: 36))
                            }

                            Button(action: {
                                showStopConfirmation = true
                            }) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 36))
                            }

                            Button(action: {
                                skipForward()
                            }) {
                                Image(systemName: "arrowshape.forward.fill")
                                    .font(.system(size: 36))
                            }
                        }
                        .padding(.bottom, 8)

                        Spacer(minLength: 0)

                        RecipeAnimationStepTracker(
                            steps: trackerSteps,
                            activeIndex: currentPhaseIndex,
                            maxHeight: trackerHeight
                        )
                    }
                    .frame(height: bottomSectionHeight)
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            } else {
                // All phases done → show summary inside the overlay
                V60RecipeSummary(recipe: recipe, showAnimation: $showAnimation)
            }
        }
        .onAppear {
            startSequence()
        }
        .onDisappear {
            stopSequence()
        }
        .alert("Stop Recipe?", isPresented: $showStopConfirmation) {
            Button("Stop", role: .destructive) {
                stopRecipe()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to stop the current recipe? This cannot be undone.")
        }
    }

    // MARK: - Timer-driven sequence

    private func startSequence() {
        stopSequence()

        startDate = Date()
        currentPhaseIndex = 0
        SoundManager.instance.playSound(sound: .nextPhase)

        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { now in
                guard let start = startDate else { return }

                let elapsed = now.timeIntervalSince(start)
                let ends = cumulativePhaseEndTimes

                if let idx = ends.firstIndex(where: { elapsed < $0 }) {
                    if idx != currentPhaseIndex {
                        currentPhaseIndex = idx
                        SoundManager.instance.playSound(sound: .nextPhase)
                    }
                } else {
                    // All phases done: stop timer and show summary
                    stopSequence()
                    SoundManager.instance.playSound(sound: .animationFinish)
                    currentPhaseIndex = phases.count  // triggers summary branch
                    // DO NOT set showAnimation = false here; summary view will handle closing.
                }
            }
    }

    private func stopSequence() {
        timer?.cancel()
        timer = nil
    }

    // MARK: - Jump / Skip

    private func jump(to phaseIndex: Int) {
        guard !phases.isEmpty else { return }

        let clampedIndex = max(0, min(phaseIndex, phases.count - 1))
        let targetElapsed = phaseStartTimes[clampedIndex]   // seconds

        startDate = Date().addingTimeInterval(-targetElapsed)

        currentPhaseIndex = clampedIndex
        SoundManager.instance.playSound(sound: .nextPhase)
    }

    private func skipForward() {
        jump(to: currentPhaseIndex + 1)
    }

    private func skipBack() {
        jump(to: currentPhaseIndex - 1)
    }

    private func trackerTitle(for index: Int, phase: V60Phase) -> String {
        if index == 0 {
            return "Bloom"
        }

        if phase.amount == 0 {
            return index == phases.count - 1 ? "Drawdown" : "Rest"
        }

        let pourIndices = phases.enumerated().compactMap { phaseIndex, phase in
            phaseIndex > 0 && phase.amount > 0 ? phaseIndex : nil
        }

        guard let pourPosition = pourIndices.firstIndex(of: index) else {
            return "Phase \(index + 1)"
        }

        if pourIndices.count == 1 || pourPosition == pourIndices.count - 1 {
            return "Final Pour"
        }

        return "\(RecipeAnimationLabels.ordinal(pourPosition + 1)) Pour"
    }

    private func trackerDetailText(amount: Int, endTime: Int) -> String {
        let pieces = [
            amount > 0 ? "\(amount)g" : nil,
            timeString(from: endTime)
        ]

        return pieces.compactMap { $0 }.joined(separator: " · ")
    }

    // MARK: - Stop

    func stopRecipe() {
        stopSequence()
        currentPhaseIndex = phases.count
        SoundManager.instance.playSound(sound: .animationFinish)

//        uncomment this to turn off summary when manually stopping
//        showAnimation = false
    }
}


#Preview {
    V60Animation(recipe: BaseRecipe<V60Info>.MOCK_V60_RECIPE, showAnimation: .constant(true))
}
