//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodListView: View {
    @StateObject private var viewModel = MethodViewModel()
    @State var imageList: [String] = ["v60", "Hario Switch"]
    
    var body: some View {
        VStack {
            Text("Methods")
                .padding(.bottom, 20)
                .italic()
                .underline()
                .font(.title)
            Text("Select a method you would like to use")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            
            VStack {
                ForEach(Array(zip(viewModel.methods, imageList)), id: \.0.self) { method, image in
                    NavigationLink {
                        RecipeListView(curMethod: method)
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

struct MethodListView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var keychainManager = KeychainManager()
        MethodListView()
            .environmentObject(keychainManager)
    }
}
