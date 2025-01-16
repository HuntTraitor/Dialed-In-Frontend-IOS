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
            // Main title, centered
            Text("Methods")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity) // Ensure title takes up full width
                .multilineTextAlignment(.center) // Center the title text

            // Subtext / Instructions, centered
            Text("Select a method you would like to use")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center) // Center the instructions text

            // Method cards, centered
            MethodCard(title: "Pour Over", image: "v60") {
                print("Pouring over")
            }
            MethodCard(title: "Hario Switch", image: "Hario Switch") {
                print("Switching all over the place")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center) // Make sure the entire VStack is centered
        .padding() // Optional: adds padding around the entire VStack
    }
}





struct MethodListView_Previews: PreviewProvider {
    static var previews: some View {
        MethodListView()
    }
}
