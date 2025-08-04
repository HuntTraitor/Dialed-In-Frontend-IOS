//
//  PourAnimationStillBorrom.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI
import Lottie

struct PourAnimationStillBottom: View {
    @State private var isExpanded = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color("WaterColor"))
                    .frame(height: isExpanded ? 0 : geometry.size.height * 0.8)

                LottieView(animation: .named("WaterAnimation"))
                    .playing(loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: isExpanded ? 0: -geometry.size.height * 0.8 + 2)
            }
        }
        .onAppear {
            isExpanded = true
        }
    }
}

#Preview {
    PourAnimationStillBottom()
}

