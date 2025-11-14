//
//  V60Animation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI
import Combine

struct V60Animation: View {
    let recipe: V60Recipe
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

    // MARK: - Body

    var body: some View {
        VStack {
            if currentPhaseIndex < recipe.info.phases.count {
                let cumulativeAmount = recipe.info.phases
                    .prefix(currentPhaseIndex + 1)
                    .reduce(0) { partial, phase in
                        partial + phase.amount
                    }

                VStack(spacing: 20) {
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

                    // Current phase header
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

                    // Animation
                    V60Pour(fillIn: Double(phases[currentPhaseIndex].time))
                        .id(currentPhaseIndex)
                }

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
                .padding(.top)
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
    V60Animation(recipe: V60Recipe.MOCK_V60_RECIPE, showAnimation: .constant(true))
}



