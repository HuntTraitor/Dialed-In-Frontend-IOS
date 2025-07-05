//
//  ChoiceDialog.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/10/25.
//

import SwiftUI

struct ChoiceDialog: View {
    @Binding var isActive: Bool
    let title: String
    let message: String
    let buttonOptions: [String]
    let action: () -> ()
    @State private var fadeInOut = false
    
    private let testingID = UIIdentifiers.Components.self
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
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
                
                HStack(spacing: 0) {
                    Button {
                        action()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color("background"))
                            
                            Text(buttonOptions[0])
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .accessibilityIdentifier(testingID.choiceDialogAcceptButton)
                    
                    Button {
                        close()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color("background"))
                            
                            Text(buttonOptions[1])
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding()
                    }
                    .accessibilityIdentifier(testingID.choiceDialogRejectButton)
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
                withAnimation(Animation.easeInOut(duration: 0.3)) {
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

#Preview {
    ChoiceDialog(isActive: .constant(true), title: "Delete", message: "Are you sure you want to delete this item?", buttonOptions: ["Yes", "No"], action: {})
}



