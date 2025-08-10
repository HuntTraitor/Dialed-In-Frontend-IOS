//
//  Timeline.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/4/25.
//

import SwiftUI

struct PourEvent {
    let id = UUID()
    let time: String
    let amount: String
    let timestamp: Date
}

struct HorizontalTimelineView: View {
    let events: [PourEvent]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    HStack(spacing: 0) {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(Color("background"))
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            
                            VStack(spacing: 2) {
                                Text(event.time)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text(event.amount)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        
                        if index < events.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 2)
                                .padding(.bottom, 35)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct PourTimelineDemo: View {
    // Sample pour events
    let sampleEvents = [
        PourEvent(time: "0:00", amount: "60ml", timestamp: Date()),
        PourEvent(time: "0:30", amount: "45ml", timestamp: Date().addingTimeInterval(30)),
        PourEvent(time: "1:15", amount: "80ml", timestamp: Date().addingTimeInterval(75)),
        PourEvent(time: "2:00", amount: "35ml", timestamp: Date().addingTimeInterval(120)),
        PourEvent(time: "2:45", amount: "50ml", timestamp: Date().addingTimeInterval(165))
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Pour Timeline")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                HorizontalTimelineView(events: sampleEvents)
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
                            Text("\(sampleEvents.count)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Amount")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("270ml")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("2:45")
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
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct PourTimelineDemo_Previews: PreviewProvider {
    static var previews: some View {
        PourTimelineDemo()
    }
}
