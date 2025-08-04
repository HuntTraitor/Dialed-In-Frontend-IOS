//
//  PourAnimation.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI
import Lottie

struct PourAnimation: View {
    let fillIn: Double
    @State private var isExpanded = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color("WaterColor"))
                    .frame(height: isExpanded ? geometry.size.height * 0.8 : 0)
                    .animation(.easeInOut(duration: fillIn), value: isExpanded)
                
                LottieView(animation: .named("WaterAnimation"))
                    .playing(loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: isExpanded ? -geometry.size.height * 0.8 : 1)
                    .animation(.easeInOut(duration: fillIn), value: isExpanded)
            }
        }
        .onAppear {
            isExpanded = true
        }
    }
}

#Preview {
    PourAnimation(fillIn: 10)
}
