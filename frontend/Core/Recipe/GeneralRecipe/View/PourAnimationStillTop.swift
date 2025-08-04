//
//  PourAnimationStill.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI
import Lottie

struct PourAnimationStillTop: View {
    @State private var isExpanded = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color("WaterColor"))
                    .frame(height: isExpanded ? geometry.size.height * 0.8 : 0)

                LottieView(animation: .named("WaterAnimation"))
                    .playing(loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: isExpanded ? -geometry.size.height * 0.8+2 : 1)
            }
        }
        .onAppear {
            isExpanded = true
        }
    }
}

#Preview {
    PourAnimationStillTop()
}
