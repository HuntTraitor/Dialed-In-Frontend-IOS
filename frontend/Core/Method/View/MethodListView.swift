//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodListView: View {
    @StateObject private var viewModel: MethodViewModel
    @State private var hasAppeared: Bool = false
    
    private let testingID = UIIdentifiers.MethodScreen.self
    
    init(viewModel: MethodViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let service = DefaultMethodService(baseURL: EnvironmentManager.current.baseURL)
            _viewModel = StateObject(wrappedValue: MethodViewModel(methodService: service))
        }
    }
    
    var body: some View {
        VStack {
            Text("Methods")
                .padding(.bottom, 20)
                .italic()
                .font(.title)
                .accessibilityIdentifier(testingID.methodTitle)
            
            Text("Select a method you would like to use")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            if viewModel.errorMessage != nil {
                FetchErrorMessageScreen(errorMessage: viewModel.errorMessage ?? "An unexpected error has occurred")
                    .scaleEffect(0.9)
                    .frame(maxHeight: 200)
                    .padding(.top, 40)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.methods) { method in
                            NavigationLink {
                                RecipeListView(curMethod: method)
                            } label: {
                                MethodCard(title: method.name, image: method.name)
                                    .padding(5)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .task {
            if !hasAppeared {
                await viewModel.fetchMethods()
                hasAppeared = true
            }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    
    let methodService = DefaultMethodService(baseURL: EnvironmentManager.current.baseURL)
    let methodViewModel = MethodViewModel(methodService: methodService)
    
    let mockMethodService = MockMethodService()
    mockMethodService.isErrorThrown = true
    let mockMethodViewModel = MethodViewModel(methodService: mockMethodService)
    
    return MethodListView(viewModel: methodViewModel)
        .environmentObject(viewModel)
}
