//
//  CoffeeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/10/25.
//

import SwiftUI

struct CoffeeCard: View {
    @State var coffee: Coffee
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: CoffeeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isChoiceDialogActive: Bool = false
    @State var isSuccessDeleteDialogActive: Bool = false
    @State var isFailureDeleteDialogActive: Bool = false
    @State private var isDetailViewPresented: Bool = false
    
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
                EditCoffeeView(coffee: $coffee, viewModel: viewModel)
            }
                
            if isChoiceDialogActive {
                ChoiceDialog(isActive: $isChoiceDialogActive, title: "Delete", message: "Are you sure you want to delete this item?", buttonOptions: ["Yes", "No"], action: deleteAction)
            }
            if viewModel.isLoading {
                LoadingCircle()
            }
            if isSuccessDeleteDialogActive {
                CustomDialog(isActive: $isSuccessDeleteDialogActive, title: "Succcess", message: "Item deleted successfully", buttonTitle: "OK", action: {
                    isSuccessDeleteDialogActive = false
                    presentationMode.wrappedValue.dismiss()
                })
            }
            if isFailureDeleteDialogActive {
                CustomDialog(isActive: $isFailureDeleteDialogActive, title: "Error", message: viewModel.errorMessage!, buttonTitle: "OK", action: {isFailureDeleteDialogActive = false})
            }
        }
    }
    
    private func deleteAction() {
        Task {
            try await viewModel.deleteCoffee(coffeeId: coffee.id, token: authViewModel.token ?? "")
            if viewModel.errorMessage != nil {
                isChoiceDialogActive = false
                isFailureDeleteDialogActive = true
            } else {
                isChoiceDialogActive = false
                isSuccessDeleteDialogActive = true
            }
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    let viewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))
    CoffeeCard(coffee: Coffee.MOCK_COFFEE, viewModel: viewModel)
        .environmentObject(authViewModel)
}
