//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodListView: View {
    
    @EnvironmentObject var methodModel: MethodViewModel
    @State var methodList: [Method] = []
    @State var imageList: [String] = ["v60", "Hario Switch"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Methods")
                    .padding(.bottom, 20)
                    .italic()
                    .underline()
                Text("Select a method you would like to use")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                
                VStack {
                    ForEach(Array(zip(methodList, imageList)), id: \.0.self) { method, image in
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
                await fetchMethods()
            }
        }
    }
    
    func fetchMethods() async {
        do {
            methodList = try await methodModel.getMethods()
        } catch {
            print("error getting methods")
        }
    }
}





struct MethodListView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = MethodViewModel()
        MethodListView()
            .environmentObject(viewModel)
    }
}
