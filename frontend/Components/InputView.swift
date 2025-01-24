//
//  InputView.swift
//  frontend
//
//  Created by Hunter Tratar on 12/10/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let icon: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isSecureField {
                HStack(spacing: 12) {
                    Spacer()
                    Image(systemName: icon)
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .padding()
                }
            } else {
                HStack(spacing: 12) {
                    Spacer()
                    Image(systemName: icon)
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .padding()
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
        )
        .padding()
    }
}


struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), icon: "envelope", placeholder: "Enter Email")
    }
}
