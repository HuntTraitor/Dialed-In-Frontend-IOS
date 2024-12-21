//
//  CustomDialog.swift
//  frontend
//
//  Created by Hunter Tratar on 12/21/24.
//

import SwiftUI

struct CustomDialog: View {
    @Binding var isActive: Bool
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> ()
    @State private var fadeInOut = false
    
    var body: some View {
        ZStack {
            Color(.white)
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(message)
                    .font(.body)
                
                Button {
                    action()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("background"))
                        
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                }
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .tint(Color("background"))
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 12)
            .padding(30)
            .onAppear() {
                withAnimation(Animation.easeInOut(duration: 0.6)) {
                    fadeInOut.toggle()
                }
            }.opacity(fadeInOut ? 1 : 0)
        }
        .ignoresSafeArea()
    }
    func close() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            fadeInOut.toggle()
            isActive = false
        }
    }
}

struct CustomDialog_Previews: PreviewProvider {
    static var previews: some View {
        CustomDialog(isActive: .constant(true), title: "Success", message: "Your registration was successful!", buttonTitle: "Close", action: {})
    }
}
