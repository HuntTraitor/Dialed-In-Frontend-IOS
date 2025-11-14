//
//  SwitchAnimation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI
import Combine

struct SwitchAnimation: View {
    let recipe: SwitchRecipe
    @Binding var showAnimation: Bool

    @State private var currentPhaseIndex: Int = 0
    @State private var startDate: Date?
    @State private var timer: AnyCancellable?

    @State private var showStopConfirmation = false

    private var phases: [SwitchPhase] {
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
                let phase = recipe.info.phases[currentPhaseIndex]
                let cumulativeAmount = recipe.info.phases
                    .prefix(currentPhaseIndex + 1)
                    .reduce(0) { partial, phase in
                        partial + phase.amount
                    }
                let currentDirection = direction(for: currentPhaseIndex)

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
                        
                        // Switch state indicator - very prominent
                        HStack(spacing: 12) {
                            Image(systemName: phase.open ? "lock.open.fill" : "lock.fill")
                                .font(.title)
                                .foregroundColor(phase.open ? .green : .red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(phase.open ? "OPEN SWITCH" : "CLOSE SWITCH")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(phase.open ? .green : .red)
                                
                                Text("Pour to \(cumulativeAmount)g")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                        }
                        .padding(.horizontal, 60)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(phase.open ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(phase.open ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Animation
                    // Animation
                    SwitchPour(fillIn: Double(phases[currentPhaseIndex].time), direction: currentDirection)
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
                SwitchRecipeSummary(recipe: recipe, showAnimation: $showAnimation)
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


extension SwitchAnimation {
    
    func direction(for phaseIndex: Int) -> Direction {
        let phases = recipe.info.phases
        
        guard phaseIndex >= 0 && phaseIndex < phases.count else {
            return .stillBottom  // default fallback
        }

        let currentPhase = phases[phaseIndex]
        
        if phaseIndex == 0 && currentPhase.open {
            if currentPhase.amount > 0 {
                return .up
            } else {
                return .stillBottom
            }
        }
        
        else if currentPhase.open {
            // if the amount is 0 and the prev amount is not zero
            if currentPhase.amount == 0 && phases[phaseIndex - 1].amount != 0 {
                return .down
            }
            // if the amount is greater than 0
            else if currentPhase.amount > 0 {
                return .up
            }
        }
        
        // if the switch is closed
        else if !currentPhase.open {
            // if the current amount is zero and the previous amount was not zero
            if currentPhase.amount == 0 && phases[phaseIndex - 1].amount != 0 {
                return .stillTop
            }
            // if the amount is greater than 0
            else if currentPhase.amount > 0 {
                return .up
            }
        }
        return .stillBottom
    }
}

#Preview {
    SwitchAnimation(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE, showAnimation: .constant(true))
}

