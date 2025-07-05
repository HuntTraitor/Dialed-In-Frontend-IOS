//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodListView: View {
    @StateObject private var viewModel: MethodViewModel
    @State var imageList: [String] = ["v60", "Hario Switch"]
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
                VStack {
                    ForEach(Array(zip(viewModel.methods, imageList)), id: \.0.self) { method, image in
                        NavigationLink {
                            RecipeListView(curMethod: method) //Metaprogramming
                        } label: {
                            MethodCard(title: method.name, image: image)
                                .padding(5)
                        }
                    }
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
    
    let mockMethodService = MockMethodService()
    mockMethodService.isErrorThrown = true
    let mockMethodViewModel = MethodViewModel(methodService: mockMethodService)
    
    return MethodListView(viewModel: mockMethodViewModel)
        .environmentObject(viewModel)
}
