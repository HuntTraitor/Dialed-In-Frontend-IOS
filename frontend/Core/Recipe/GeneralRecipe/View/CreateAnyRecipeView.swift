//
//  CreateAnyRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/12/25.
//

import SwiftUI

struct CreateAnyRecipeView: View {
    @EnvironmentObject private var viewModel: MethodViewModel
    @State private var selectedMethod: Method? = nil
    @State private var isShowingMethodSheet = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.brown)
                        .padding(.top, 20)
                    
                    Text("Choose Your Brewing Method")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text("Select a method to create your perfect recipe")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                if viewModel.errorMessage != nil {
                    FetchErrorMessageScreen(errorMessage: viewModel.errorMessage ?? "An unexpected error has occurred")
                        .scaleEffect(0.9)
                        .frame(maxHeight: 200)
                        .padding(.horizontal)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.methods) { method in
                                Button {
                                    selectedMethod = method
                                } label: {
                                    MethodCardSmall(title: method.name, image: method.name)
                                        .scaleEffect(0.98)
                                        .animation(.easeInOut(duration: 0.1), value: false)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    .sheet(item: $selectedMethod) { method in
                        NavigationStack {
                            CreateAnyRecipeRow(curMethod: method)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchMethods()
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            CreateAnyRecipeView()
        }
    }
}

