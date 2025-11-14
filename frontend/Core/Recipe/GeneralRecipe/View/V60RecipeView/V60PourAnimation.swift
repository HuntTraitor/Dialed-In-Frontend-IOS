//
//  V60PourAnimation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI
import Lottie

struct V60PourAnimation: View {
    let fillIn: Double
    @State private var isExpanded = false
    
    private var riseDuration: Double { fillIn * 0.35 }
    private var fallDuration: Double { fillIn * 0.65 }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Water fill
                Rectangle()
                    .fill(Color("WaterColor"))
                    .frame(height: isExpanded ? geometry.size.height * 0.8 : 0)
                
                // Lottie water surface
                LottieView(animation: .named("WaterAnimation"))
                    .playing(loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .bottom
                    )
                    .offset(
                        y: isExpanded
                        ? -geometry.size.height * 0.8 + 2
                        : 1
                    )
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        isExpanded = false
        
        // Rise (35%)
        withAnimation(.easeInOut(duration: riseDuration)) {
            isExpanded = true
        }
        
        // Fall (65%) after rise completes
        DispatchQueue.main.asyncAfter(deadline: .now() + riseDuration) {
            withAnimation(.easeInOut(duration: fallDuration)) {
                isExpanded = false
            }
        }
    }
}


#Preview {
    V60PourAnimation(fillIn: 10)
}


