//
//  CountdownDialog.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/24/25.
//

import SwiftUI

struct CountdownDialog: View {
    let seconds: Int
    var onComplete: (() -> Void)? = nil
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    
    init(seconds: Int, onComplete: (() -> Void)? = nil) {
        self.seconds = seconds
        self.onComplete = onComplete
        self._remainingSeconds = State(initialValue: seconds)
    }
    
    var body: some View {
        VStack {
            Text("Starting in \(remainingSeconds)...")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 80)
        .background(Color.gray.opacity(0.8))
        .cornerRadius(20)
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                timer?.invalidate()
                onComplete?()
            }
        }
    }
}

#Preview {
    CountdownDialog(seconds: 3)
}

