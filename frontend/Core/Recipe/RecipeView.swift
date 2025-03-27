//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeView: View {
    let recipe: SwitchRecipe
    @EnvironmentObject var coffeeModel: CoffeeViewModel
    @EnvironmentObject var keychainManager: KeychainManager
    @State private var showCountdown = false
    @State private var showAnimation = false
    
    private var sortedPhases: [(key: Int, value: SwitchRecipe.RecipeInfo.Phase)] {
        recipe.info.phases.sorted { $0.key < $1.key }
    }
    
    private var totalTime: Int {
        sortedPhases.reduce(0) { $0 + $1.value.time }
    }
    
    private var phaseColors: [Color] {
        sortedPhases.enumerated().map { getColor(for: $0.offset) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content (always present)
                mainContent
                    .opacity(showAnimation ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: showAnimation)
                
                // Countdown overlay
                if showCountdown {
                    CountdownDialog(
                        seconds: 3,
                        onComplete: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showCountdown = false
                                showAnimation = true
                                print("COMPLETED HERE")
                            }
                        }
                    )
                    .zIndex(1)
                    .transition(.opacity)
                }
                
                // Full-screen animation
                if showAnimation {
                    RecipeAnimation(recipe: recipe) {
                        print("Animation Complete")
                    }
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(2)
                    .transition(.opacity)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Recipe header
                VStack {
                    Text(recipe.info.name)
                        .font(.title)
                        .italic()
                        .bold()
                        .padding(.bottom, 5)
                    
                    NavigationLink {
                        CoffeeCard(coffee: recipe.coffee)
                            .environmentObject(keychainManager)
                            .environmentObject(coffeeModel)
                    } label: {
                        CoffeeCardSmall(coffee: recipe.coffee)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Brew metrics
                HStack(spacing: 30) {
                    VStack {
                        Image(systemName: "scalemass.fill")
                        Text("\(recipe.info.gramsIn)g")
                    }
                    
                    VStack {
                        Image(systemName: "drop.fill")
                        Text("\(recipe.info.mlOut)ml")
                    }
                }
                .font(.headline)
                .padding(.bottom, 10)
                
                // Brew visualization
                brewVisualization
                    .padding(.vertical, 20)
                
                // Start button
                Button {
                    showCountdown = true
                } label: {
                    Text("Start Brewing")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("background"))
                .padding(.horizontal, 40)
                .padding(.top, 10)
            }
            .padding()
        }
    }
    
    private var brewVisualization: some View {
        VStack {
            // Timer circle visualization
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 25)
                    )
                
                // Phase segments
                ForEach(Array(sortedPhases.enumerated()), id: \.offset) { index, phase in
                    let slice = CGFloat(phase.value.time) / CGFloat(totalTime)
                    let startAngle = sortedPhases.prefix(index).reduce(0) { $0 + CGFloat($1.value.time)/CGFloat(totalTime) }
                    let endAngle = startAngle + slice
                    
                    Circle()
                        .trim(from: startAngle, to: endAngle)
                        .stroke(
                            phaseColors[index],
                            style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 250, height: 250)
                }
                
                // Total time display
                Text(totalTimeString)
                    .font(.system(size: 50, weight: .black))
            }
            
            // Phase legend
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(sortedPhases.enumerated()), id: \.offset) { index, phase in
                    HStack {
                        Rectangle()
                            .fill(phaseColors[index])
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading) {
                            Text("Phase \(phase.key + 1)")
                                .font(.headline)
                            Text("\(phase.value.time)s - \(phase.value.amount)g")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Image(systemName: phase.value.open ? "lock.open" : "lock")
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
    }
    
    private var totalTimeString: String {
        String(format: "%d:%02d", totalTime / 60, totalTime % 60)
    }
    
    private func getColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .red, .yellow]
        return colors[index % colors.count]
    }
}

#Preview {
    RecipeView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
        .environmentObject(CoffeeViewModel())
        .environmentObject(KeychainManager())
}
