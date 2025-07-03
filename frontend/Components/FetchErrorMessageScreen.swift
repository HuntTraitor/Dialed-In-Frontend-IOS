//
//  FetchErrorMessageScreen.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/2/25.
//

import SwiftUI

struct FetchErrorMessageScreen: View {
    var errorCode: Int?
    var errorMessage: String?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .opacity(0.3)

            Text("Unable to load data")
                .font(.headline)
                .foregroundColor(.primary)
                .opacity(0.4)

            if let message = errorMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            if let code = errorCode {
                Text("Error code: \(code)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


#Preview {
    FetchErrorMessageScreen(errorCode: 500, errorMessage: "Unable to fetch coffees, please try again")
}

