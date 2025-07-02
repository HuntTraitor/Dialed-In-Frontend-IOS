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
    
    init() {
        let service = DefaultMethodService(baseURL: EnvironmentManager.current.baseURL)
        _viewModel = StateObject(wrappedValue: MethodViewModel(methodService: service))
    }
    
    var body: some View {
        VStack {
            Text("Methods")
                .padding(.bottom, 20)
                .italic()
                .font(.title)
            Text("Select a method you would like to use")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            
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
        .padding()
        .task {
            do {
                await viewModel.fetchMethods()
            }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    MethodListView()
        .environmentObject(viewModel)
}
