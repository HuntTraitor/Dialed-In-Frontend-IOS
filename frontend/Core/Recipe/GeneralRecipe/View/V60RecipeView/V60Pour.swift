//
//  V60Pour.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI
import Lottie
import Combine

enum V60Direction {
    case up, down
}

struct V60Pour: View {
    let fillIn: Double
    
    @State private var remainingTime: Double
    @State private var timer: AnyCancellable?
    
    init(fillIn: Double) {
        self.fillIn = fillIn
        _remainingTime = State(initialValue: fillIn+0.9)
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                V60PourAnimation(fillIn: min(fillIn, 40))
                    .frame(width: 230, height: 130)
                    .offset(y: -1)

                Image("V60 animation logo")
                    .resizable()
            }
            .frame(width: 230, height: 200)

            LottieView(animation: .named("LoadingBar"))
                .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
                .animationSpeed(animationSpeed)
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .offset(y: -30)

            Text(timeString(from: Int(max(remainingTime, 0))))
                .font(.system(size: 24, weight: .medium, design: .monospaced))
                .padding(.top, -50)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.cancel()
        }
    }

    private var animationSpeed: Double {
        let originalDuration = 5.94
        return originalDuration / fillIn
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingTime > 0 {
                    remainingTime -= 0.1
                } else {
                    timer?.cancel()
                }
            }
    }
}


#Preview {
    V60Pour(fillIn: 200)
}

