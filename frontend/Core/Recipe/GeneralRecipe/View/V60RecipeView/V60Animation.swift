//
//  V60Animation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI

struct V60Animation: View {
    let recipe: V60Recipe
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
                        
                        // Pour state indicator - very prominent
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
                    V60Pour(fillIn: Double(phase.time))
                        .id(currentPhaseIndex)
                        .transition(.opacity.combined(with: .scale))
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
                V60RecipeSummary(recipe: recipe, showAnimation: $showAnimation)
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

#Preview {
    V60Animation(recipe: V60Recipe.MOCK_V60_RECIPE, showAnimation: .constant(true))
}



