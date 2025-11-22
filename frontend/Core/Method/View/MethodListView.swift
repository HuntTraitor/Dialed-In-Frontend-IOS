//
//  MethodListView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/15/25.
//

import SwiftUI
import WrappingHStack

struct MethodListView: View {
    @EnvironmentObject private var viewModel: MethodViewModel
    @State private var hasAppeared: Bool = false
    
    private let testingID = UIIdentifiers.MethodScreen.self
    
    var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Text("Methods")
                    .padding(.top, 20)
                    .italic()
                    .font(.title)
                    .accessibilityIdentifier(testingID.methodTitle)
                
                Text("Select a method you would like to use")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                ScrollView {
                
                if let error = viewModel.errorMessage {
                    FetchErrorMessageScreen(errorMessage: error)
                        .scaleEffect(0.9)
                        .frame(maxHeight: 200)
                        .padding(.top, 40)
                } else {
                    VStack {
                        ForEach(viewModel.methods) { method in
                            NavigationLink {
                                GeneralRecipeView(curMethod: method)
                            } label: {
                                MethodCard(title: method.name, image: method.name)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

                    LazyVGrid(columns: columns, spacing: 8) {
                        GenericHomeSelectorBox(title: "Common Recipes", icon: "list.bullet.rectangle.portrait")
                        GenericHomeSelectorBox(title: "Method Guide", icon: "flag.badge.ellipsis")
                        GenericHomeSelectorBox(title: "Term Information", icon: "pencil.and.outline")
                        GenericHomeSelectorBox(title: "Landing Page", icon: "airplane.departure")
                        GenericHomeSelectorBox(title: "About", icon: "info.square")
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
            await viewModel.fetchMethods()
        }
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
