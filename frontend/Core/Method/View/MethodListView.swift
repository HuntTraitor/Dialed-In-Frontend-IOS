//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI

struct MethodListView: View {
    @EnvironmentObject private var viewModel: MethodViewModel
    @State private var hasAppeared: Bool = false
    
    private let testingID = UIIdentifiers.MethodScreen.self
    
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
                                GeneralRecipeView(curMethod: method)
                            } label: {
                                MethodCard(title: method.name, image: method.name)
                                    .padding(5)
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await Task {
                        await viewModel.fetchMethods()
                    }.value
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
    PreviewWrapper {
        NavigationStack {
            MethodListView()
        }
    }
}
