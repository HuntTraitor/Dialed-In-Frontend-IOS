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
                    ForEach(methodList, id: \.self) { method in
                        NavigationLink {
                            RecipeListView(curMethod: method)
                        } label: {
                            MethodCard(title: method.name, image: method.img)
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
