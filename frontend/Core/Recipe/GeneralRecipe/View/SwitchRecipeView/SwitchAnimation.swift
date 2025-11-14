//
//  SwitchAnimation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI

struct SwitchAnimation: View {
    let recipe: SwitchRecipe
    @State private var currentPhaseIndex = 0
    @State private var targetPhaseIndex = 0
    @State private var currentTask: Task<Void, Never>? = nil
    @State private var isPlaying = true
    @State private var showStopConfirmation = false
    @Binding var showAnimation: Bool


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
                        Text("Phase \(currentPhaseIndex + 1) of \(recipe.info.phases.count)")
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
                    SwitchPour(fillIn: Double(phase.time), direction: currentDirection)
                        .id(currentPhaseIndex)
                        .transition(.opacity.combined(with: .scale)) // fade instead of flicker
                        .animation(.easeInOut, value: currentPhaseIndex)
                }
                
                HStack(spacing: 40) {
                    Button(action: {
                        skipBackward()
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
                SwitchRecipeSummary(recipe: recipe, showAnimation: $showAnimation)
            }
        }
        .onAppear {
            runPhaseSequence()
        }
        .onDisappear {
            currentTask?.cancel()
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
    
    func runPhaseSequence() {
        currentTask?.cancel()
        currentTask = Task {
            for i in currentPhaseIndex..<recipe.info.phases.count {
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    currentPhaseIndex = i
                    SoundManager.instance.playSound(sound: .nextPhase)
                }

                let time = recipe.info.phases[i].time
                try? await Task.sleep(nanoseconds: UInt64(Double(time) * 1_000_000_000))
            }

            guard !Task.isCancelled else { return }
            await MainActor.run {
                print("hi")
                currentPhaseIndex = recipe.info.phases.count
                SoundManager.instance.playSound(sound: .animationFinish)
            }
        }
    }

    func skipForward() {
        guard currentPhaseIndex < recipe.info.phases.count - 1 else { return }
        currentTask?.cancel()
        currentPhaseIndex += 1
        runPhaseSequence()
    }

    func skipBackward() {
        guard currentPhaseIndex > 0 else { return }
        currentTask?.cancel()
        currentPhaseIndex -= 1
        runPhaseSequence()
    }
    
    func stopRecipe() {
        currentTask?.cancel()
        currentPhaseIndex = recipe.info.phases.count
        SoundManager.instance.playSound(sound: .animationFinish)
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

