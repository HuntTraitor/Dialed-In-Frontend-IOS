//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeView: View {
    let recipe: SwitchRecipe
    
    var body: some View {
        let sortedPhases = recipe.info.phases.sorted { $0.key < $1.key }
        let totalTime = sortedPhases.reduce(0) { $0 + $1.value.time }
        
        let phaseColors = sortedPhases
            .enumerated()
            .map { getColor(for: $0.offset) }

        VStack {
            HStack {
                Image(systemName: "cup.and.heat.waves.fill")
                Text("Milky Cake")
            }
            HStack {
                Image(systemName: "cup.and.heat.waves.fill")
                    .foregroundColor(Color("background"))
                Text("\(recipe.info.gramsIn)g")
                Image(systemName: "cup.and.heat.waves.fill")
                    .foregroundColor(Color("background"))
            }
            .padding()
            
            HStack(spacing: 40) {
                ZStack {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 25)
                        )
                    
                    let phaseSlices = sortedPhases
                        .map { CGFloat($0.value.time) / CGFloat(totalTime) }
                    
                    ForEach(Array(phaseSlices.enumerated()), id: \.0) { index, slice in
                        let startAngle = phaseSlices.prefix(index).reduce(0, +)
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
                    
                    Text(String(format: "%d:%02d", totalTime / 60, totalTime % 60))
                        .font(.system(size: 60))
                        .fontWeight(.black)
                }
                .padding(.leading, 20)
                
                VStack(spacing: 8) {
                    ForEach(Array(sortedPhases.enumerated()), id: \.offset) { index, phase in
                        HStack {
                            Image(systemName: phase.value.open ? "lock.open" : "lock")
                            Text("\(phase.value.amount)g")
                                .frame(width: 40, alignment: .leading)
                            
                            Rectangle()
                                .fill(phaseColors[index])
                                .frame(width: 20, height: 20)
                        }
                        .padding(.trailing, 20)
                    }
                }
                .frame(width: 100)
            }
            .padding()
            
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(Color("background"))
                Text("\(recipe.info.mlOut)ml")
                Image(systemName: "drop.fill")
                    .foregroundColor(Color("background"))
            }
            
            Button {
                // TODO: Start animation
            } label: {
                Text("Start")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .background(Color("background"))
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.horizontal, 40)
            .padding(.top, 24)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 6)
        }
    }
    
    private func getColor(for index: Int) -> Color {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
        return colors[index % colors.count]
    }
}

#Preview {
    RecipeView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}
