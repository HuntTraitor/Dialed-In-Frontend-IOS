//
//  CoffeeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/10/25.
//

import SwiftUI

struct CoffeeCard: View {
    @State private var coffee: Coffee
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var keyChainManager: KeychainManager
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    @State var isChoiceDialogActive: Bool = false
    @State var isSuccessDeleteDialogActive: Bool = false
    @State var isFailureDeleteDialogActive: Bool = false
    @State var errorMessage: String?
    @State private var refreshData: Bool = false
    @State private var isDetailViewPresented: Bool = false
    
    init(coffee: Coffee) {
        _coffee = State(initialValue: coffee)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        isDetailViewPresented = true
                    }) {
                        Text("Edit")
                            .font(.body)
                    }
                    Spacer()
                }
                .padding(.leading, 40)
                ZStack {
                    VStack(spacing: 0){
                        Text(coffee.name)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                            .font(.custom("Italianno-Regular", size: 45))
                            .underline()
                        VStack {
                            ImageView(URL(string: coffee.img!))
                        }
                        .frame(minHeight: 200, maxHeight: 300)
                        .padding(.bottom, 10)
                        
                        HStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Text("Region")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading, 4)
                                    .padding(.top, 4)
                                    .italic()
                                
                                Text(coffee.region)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .font(.system(size: 12))
                                    .offset(y: -8)
                                
                            }
                            .border(Color.black)
                            
                            VStack(spacing: 0) {
                                Text("Process")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading, 4)
                                    .padding(.top, 4)
                                    .italic()
                                Text(coffee.process)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .font(.system(size: 12))
                                    .offset(y: -8)
                            }
                            .border(Color.black)
                        }
                        
                        
                        ZStack(alignment: .topLeading) {
                            Text("Description")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .padding(4)
                                .italic()
                            Text(coffee.description)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                                .padding()
                                .padding(.top, 10)
                        }
                    
                        
                        Spacer()
                    }
                    
                    .frame(width: 350, height: 500)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
                    
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("background"))
                    .frame(height: 40)
                    .shadow(radius: 3)
                    .overlay(
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        isChoiceDialogActive = true
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 10)
            }
            .sheet(isPresented: $isDetailViewPresented) {
                EditCoffeeView(coffee: $coffee, refreshData: $refreshData)
            }
                
            if isChoiceDialogActive {
                ChoiceDialog(isActive: $isChoiceDialogActive, title: "Delete", message: "Are you sure you want to delete this item?", buttonOptions: ["Yes", "No"], action: deleteAction)
            }
            if isLoading {
                LoadingCircle()
            }
            if isSuccessDeleteDialogActive {
                CustomDialog(isActive: $isSuccessDeleteDialogActive, title: "Succcess", message: "Item deleted successfully", buttonTitle: "OK", action: {
                    isSuccessDeleteDialogActive = false
                    presentationMode.wrappedValue.dismiss()
                })
            }
            if isFailureDeleteDialogActive {
                CustomDialog(isActive: $isFailureDeleteDialogActive, title: "Error", message: "Failed to delete coffee, \(String(describing: errorMessage!))", buttonTitle: "OK", action: {isFailureDeleteDialogActive = false})
            }
        }
    }
    
    private func deleteAction() {
        Task {
            isLoading = true
            defer {isLoading = false}
            do {
                try await coffeeViewModel.deleteCoffee(coffeeId: coffee.id, token: keyChainManager.getToken())
                isChoiceDialogActive = false
                isSuccessDeleteDialogActive = true
            } catch {
                print("❌ Error deleting coffee, \(error)")
                switch error {
                case CustomError.methodError(let message):
                    if let rangeStart = message.range(of: "\"error\": "),
                       let rangeEnd = message.range(of: "]", range: rangeStart.upperBound..<message.endIndex) {
                        let errorDetail = message[rangeStart.upperBound..<rangeEnd.lowerBound]
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: "\"", with: "")
                        print("Extracted Error: \(errorDetail)")
                        errorMessage = errorDetail
                    } else {
                        print("Could not extract error details from message.")
                    }
                default:
                    print("An unknown error occurred")
                }
                isChoiceDialogActive = false
                isFailureDeleteDialogActive = true
            }
        }
    }
}


#Preview {
    let keychainManager = KeychainManager()
    let coffeeViewModel = CoffeeViewModel()
    return CoffeeCard(
        coffee: Coffee.MOCK_COFFEE
    )
    .environmentObject(keychainManager)
    .environmentObject(coffeeViewModel)
    
}
