//
//  CountdownTimer.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct CountdownTimer: View {
    @State private var counter: Int = 0
    private var seconds: Int
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 25)
                    )
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle().trim(from: 0, to: progress())
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: 25,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .foregroundColor(completed() ? Color("background") : Color("background"))
                            .animation(.easeInOut(duration: 0.5), value: progress())
                    )
                
                Clock(counter: counter, countTo: seconds)
            }
        }
        .onReceive(timer) { _ in
            if self.counter < self.seconds {
                self.counter += 1
            }
        }
        .onChange(of: seconds) { oldSeconds, newSeconds in
            counter = 0 // Reset counter when seconds change
        }
    }
    
    func completed() -> Bool {
        return counter >= seconds
    }
    
    func progress() -> CGFloat {
        return CGFloat(counter) / CGFloat(seconds)
    }
}

struct Clock: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.system(size: 60))
                .fontWeight(.black)
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = currentTime / 60
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}

#Preview {
    CountdownTimer(seconds: 10)
}
