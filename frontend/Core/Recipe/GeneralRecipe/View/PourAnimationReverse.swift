//
//  PourAnimationReverse.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI
import Lottie

struct PourAnimationReverse: View {
    let fillIn: Double
    @State private var isExpanded = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color("WaterColor"))
                    .frame(height: isExpanded ? 0 : geometry.size.height * 0.8)
                    .animation(.easeInOut(duration: fillIn), value: isExpanded)
                
                LottieView(animation: .named("WaterAnimation"))
                    .playing(loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: isExpanded ? 0: -geometry.size.height * 0.8 + 2)
                    .animation(.easeInOut(duration: fillIn), value: isExpanded)
            }
        }
        .onAppear {
            isExpanded = true
        }
    }
}

#Preview {
    PourAnimationReverse(fillIn: 10)
}

