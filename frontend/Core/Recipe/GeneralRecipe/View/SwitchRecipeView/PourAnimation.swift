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
                    .frame(height: isExpanded ? geometry.size.height : 0)
                    .animation(.easeInOut(duration: fillIn), value: isExpanded)
                
                LottieView(animation: .named("WaterAnimation"))
                    .playing(loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: isExpanded ? -geometry.size.height + 1 : 1)
                    .animation(.easeInOut(duration: fillIn), value: isExpanded)
            }
            .offset(y: 35)
        }
        .onAppear {
            isExpanded = true
        }
    }
}

#Preview {
    PourAnimation(fillIn: 10)
}
