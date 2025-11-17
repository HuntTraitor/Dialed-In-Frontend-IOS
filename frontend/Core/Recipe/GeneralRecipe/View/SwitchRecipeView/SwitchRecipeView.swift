//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct SwitchRecipeView: View {
    @State var recipe: SwitchRecipe
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showCountdown = false
    @State private var showAnimation = false
    @State private var isMinimized: Bool = true
    @State private var isShowingEditRecipeView: Bool = false
    
    private var sortedPhases: [SwitchPhase] {
        recipe.info.phases
    }
    
    private var totalTime: Int {
        sortedPhases.reduce(0) { $0 + $1.time }
    }
    
    var body: some View {
        ZStack {
            mainContent
                .opacity(showAnimation ? 0 : 1)

            if showAnimation {
                VStack {
                    SwitchAnimation(recipe: recipe, showAnimation: $showAnimation)
                        .padding(.top, 40)
                    Spacer()
                }
                .zIndex(2)
                .transition(.opacity)
            }

            if showCountdown {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(3)

                CountdownDialog(
                    seconds: 3,
                    onComplete: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCountdown = false
                            showAnimation = true
                        }
                    }
                )
                .zIndex(4)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showCountdown)
        .animation(.easeInOut(duration: 0.3), value: showAnimation)
        .toolbar(showAnimation ? .hidden : .visible, for: .tabBar)
        .toolbar(showAnimation ? .hidden : .visible, for: .navigationBar)
        .navigationBarBackButtonHidden(showAnimation)
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Recipe title
                Text(recipe.info.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                HStack(spacing: 40) {
                    VStack {
                        Text("\(recipe.info.gramsIn)g")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Coffee")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)
                    
                    VStack {
                        Text("\(recipe.info.mlOut)ml")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Output")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(totalTime)s")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Total Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                if let coffee = recipe.coffee {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Coffee", systemImage: "leaf.fill")
                                .font(.headline)
                                .foregroundColor(.brown)
                            
                            Spacer()
                            
                            Button(action: {
                                isMinimized.toggle()
                            }) {
                                Image(systemName: isMinimized ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                                    .foregroundColor(.brown)
                                    .font(.title3)
                            }
                        }
                        
                        NavigationLink {
                            CoffeeCard(coffee: coffee)
                        } label: {
                            CoffeeRow(coffee: coffee, isMinimized: $isMinimized)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.brown.opacity(0.15), lineWidth: 1)
                    )
                }
                
                brewVisualization
                
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
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingEditRecipeView = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                        }
                    }
                }
                .sheet(isPresented: $isShowingEditRecipeView) {
                    NavigationStack {
                        SwitchEditRecipeView(recipe: $recipe)
                    }
                }
            }
            .padding()
        }
    }
    
    private var brewVisualization: some View {
        VStack {
            VStack(spacing: 0) {
                SwitchRecipeViewImage(recipe: recipe)
                Text(timeString(from: totalTime))
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
            }
            

            // Phase legend
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(sortedPhases.enumerated()), id: \.offset) { index, phase in
                    HStack {
                        Rectangle()
                            .fill(brownShade(for: index, total: sortedPhases.count))
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading) {
                            Text("Phase \(index + 1)")
                                .font(.headline)
                            Text("\(phase.time)s - \(phase.amount)g")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Image(systemName: phase.open ? "lock.open" : "lock")
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            SwitchRecipeView(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
        }
    }
}
