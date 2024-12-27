//
//  LoadingCircle.swift
//  frontend
//
//  Created by Hunter Tratar on 12/26/24.
//

import SwiftUI

struct LoadingCircle: View {
    @State var rotation: Double = 360
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.1)
                .ignoresSafeArea()
            
            Circle()
                .trim(from: 1/2, to: 1)
                .stroke(Color("background"), lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(self.rotation))
                .onAppear() {if self.rotation == 0 {self.rotation = 360} else {self.rotation = 0}}
                .onAppear {
                    withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }}
    }
}

struct LoadingCirlce_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCircle()
    }
}
