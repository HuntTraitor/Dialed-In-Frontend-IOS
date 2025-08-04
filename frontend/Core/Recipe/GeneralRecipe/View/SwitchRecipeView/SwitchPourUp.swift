//
//  SwitchPourUp.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/3/25.
//

import SwiftUI

struct SwitchPourUp: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            PourAnimation(fillIn: 5)
                .frame(width: 230, height: 130)
                .offset(y: -1)
            Image("V60 animation logo")
                .resizable()
        }
        .frame(width: 230, height: 200)
    }
}

#Preview {
    SwitchPourUp()
}

