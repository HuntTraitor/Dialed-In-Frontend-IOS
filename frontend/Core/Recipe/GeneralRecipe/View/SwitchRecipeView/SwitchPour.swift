//
//  SwitchPourUp.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI

enum Direction {
    case up, down, stillTop, stillBottom
}

struct SwitchPour: View {
    let fillIn: Double
    let direction: Direction
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            switch direction {
            case .up:
                PourAnimation(fillIn: fillIn)
                    .frame(width: 230, height: 130)
                    .offset(y: -1)
            case .down:
                PourAnimationReverse(fillIn: fillIn)
                    .frame(width: 230, height: 130)
                    .offset(y: -1)
            case .stillTop:
                PourAnimationStillTop()
                    .frame(width: 230, height: 130)
                    .offset(y: -1)
            case .stillBottom:
                PourAnimationStillBottom()
                    .frame(width: 230, height: 130)
                    .offset(y: -1)
            }
            Image("V60 animation logo")
                .resizable()
        }
        .frame(width: 230, height: 200)
    }
}

#Preview {
    SwitchPour(fillIn: 5, direction: .stillBottom)
}

