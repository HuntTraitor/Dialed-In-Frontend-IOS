//
//  SwitchRecipeSummary.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/4/25.
//

import SwiftUI
import Lottie

struct SwitchRecipeSummary: View {
    var recipe: SwitchRecipe
    var brewTime: String {
        timeString(from: recipe.info.phases.reduce(0) { $0 + $1.time })
    }
    var waterAmount: Int {
        recipe.info.phases.reduce(0) { $0 + $1.amount }
    }
    var cups: String {
        String(format: "%.1f", Double(recipe.info.phases.reduce(0) { $0 + $1.amount }) / 250)
    }
    
    var events: [PourEvent] {
        let pourEvents: [PourEvent] = recipe.info.phases.map { phase in
            let timeStr = timeString(from: phase.time)
            let amountStr = "\(Int(phase.amount))ml"
            let timestamp = Date().addingTimeInterval(TimeInterval(phase.time))
            
            return PourEvent(time: timeStr, amount: amountStr, timestamp: timestamp)
        }
        return pourEvents
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Lottie Animation and completion message
                VStack {
                    LottieView(animation: .named("CoffeeLove"))
                        .playing(loopMode: .loop)
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("All Done!")
                    Text("Enjoy your brew of \(recipe.coffee.info.name)")
                }
                
                // 2x2 grid
                Grid {
                    GridRow {
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .border(Color("background"))
                                .aspectRatio(1, contentMode: .fit)
                            VStack {
                                Text("Coffee")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(recipe.info.gramsIn)g")
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .border(Color("background"))
                                .aspectRatio(1, contentMode: .fit)
                            VStack {
                                Text("Water")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(recipe.info.mlOut)g")
                            }
                        }
                    }
                    GridRow {
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .border(Color("background"))
                                .aspectRatio(1, contentMode: .fit)
                            VStack {
                                Text("Cups")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(cups)")
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .border(Color("background"))
                                .aspectRatio(1, contentMode: .fit)
                            VStack {
                                Text("BrewTime")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(brewTime)")
                            }
                        }
                    }
                }
                .frame(maxWidth: 280)
                .padding(.horizontal)
                
                Divider()
                
                // Timeline section (removed NavigationView wrapper)
                VStack(spacing: 20) {
                    Text("Pour Timeline")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HorizontalTimelineView(events: events)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    // Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Pours")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(events.count)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Total Amount")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(waterAmount)ml")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Duration")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(brewTime)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color("background").opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                
                // Coffee Info section
                VStack(spacing: 20) {
                    Text("Coffee")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    CoffeeCardExtraSmall(coffee: recipe.coffee)
                    
                    HStack(alignment: .top) {
                        Text("Taste Notes")
                            .foregroundColor(.gray)
                        Spacer()
                        TastingNotesView(notes: recipe.coffee.info.tastingNotes ?? [])
                    }
                    .padding(.horizontal, 30)
                    
                    HStack(alignment: .top) {
                        Text("Notes")
                            .foregroundColor(.gray)
                        Spacer()
                        ScrollView {
                            Text(recipe.coffee.info.description ?? "")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                        }
                        .frame(width: 210, height: 120)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                }
            }
            .padding(.vertical)
        }
        
    }
}

#Preview {
    SwitchRecipeSummary(recipe: SwitchRecipe.MOCK_SWITCH_RECIPE)
}
