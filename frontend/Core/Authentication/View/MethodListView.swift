//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodListView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Methods")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding()

            Text("Select a method you would like to use")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            MethodCard(title: "Pour Over", image: "v60") {
                print("Pouring over")
            }
            MethodCard(title: "Hario Switch", image: "Hario Switch") {
                print("Switching all over the place")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}





struct MethodListView_Previews: PreviewProvider {
    static var previews: some View {
        MethodListView()
    }
}
