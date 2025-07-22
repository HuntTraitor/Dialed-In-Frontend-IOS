//
//  CoffeeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/10/25.
//

import SwiftUI
import WrappingHStack

struct CoffeeCard: View {
    @State var coffee: Coffee
//    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CoffeeViewModel
    @Environment(\.presentationMode) var presentationMode
//    @State var isChoiceDialogActive: Bool = false
//    @State var isSuccessDeleteDialogActive: Bool = false
//    @State var isFailureDeleteDialogActive: Bool = false
//    @State private var isDetailViewPresented: Bool = false
//    let title: String
//    let keyValuePairs: [(String, String)]
    @State private var isGeneralExpanded = true
    @State private var isRoastExpanded = true
    @State private var isTasteExpanded = true
    @State private var isShowingEditCoffeeView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                ZStack(alignment: .topTrailing) {
                    // Image centered horizontally
                    HStack {
                        Spacer()
                        if let imgString = coffee.info.img, !imgString.isEmpty, let url = URL(string: imgString) {
                            ImageView(url)
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 16)
                        }
                        Spacer()
                    }

                    Button(action: {
                        isShowingEditCoffeeView = true
                    }) {
                        Image(systemName: "pencil")
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding([.top, .trailing], 16)

                    .sheet(isPresented: $isShowingEditCoffeeView) {
                        EditCoffeeView(coffee: $coffee)
                    }
                }

                // General Section
                DisclosureGroup(isExpanded: $isGeneralExpanded) {
                    VStack(alignment: .leading, spacing: 12) {
                        KeyValueView(key: "Name", value: coffee.info.name)
                        Divider()
                        KeyValueView(key: "Roaster", value: coffee.info.roaster ?? "-")
                        Divider()
                        KeyValueView(key: "Cost", value: String(format: "$%.2f", coffee.info.cost ?? 0.0))
                    }
                    .padding()
                } label: {
                    Text("General")
                        .font(.headline)
                }
                .cardStyle()

                // Roast Section
                DisclosureGroup(isExpanded: $isRoastExpanded) {
                    VStack(alignment: .leading, spacing: 10) {
                        KeyValueView(key: "Region", value: coffee.info.region ?? "-")

                        Divider()
                        KeyValueView(key: "Process", value: coffee.info.process ?? "-")

                        Divider()
                        KeyValueView(
                            key: "Origin Type",
                            value: (coffee.info.originType == .unknown || coffee.info.originType == nil)
                                ? "-"
                                : coffee.info.originType!.displayName
                        )
                        Divider()
                        KeyValueView(
                            key: "Roast Level",
                            value: (coffee.info.roastLevel == .unknown || coffee.info.roastLevel == nil)
                                ? "-"
                            : coffee.info.roastLevel!.displayName
                        )
                        Divider()
                        HStack {
                            Text("Decaf?")
                                .foregroundColor(.gray)
                            Spacer()
                            if coffee.info.decaf == true {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("background"))
                                    .font(.title2)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding()
                } label: {
                    Text("Roast")
                        .font(.headline)
                }
                .cardStyle()

                // Taste Section
                DisclosureGroup(isExpanded: $isTasteExpanded) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Rating")
                                .foregroundColor(.gray)
                            Spacer()
                            StarRatingView(rating: coffee.info.rating?.rawValue ?? .zero)
                        }
                        Divider()
                        HStack(alignment: .top) {
                            Text("Taste Notes")
                                .foregroundColor(.gray)
                            TastingNotesView(notes: coffee.info.tastingNotes ?? [])
                        }
                        
                        Divider()
                        HStack(alignment: .top) {
                            Text("Notes")
                                .foregroundColor(.gray)
                            Spacer()
                            ScrollView {
                                Text(coffee.info.description ?? "")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                            }
                            .frame(width: 210, height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                } label: {
                    Text("Taste")
                        .font(.headline)
                }
                .cardStyle()
            }
            .padding()
        }
        .background(Color(.systemGray5))
    }


}

struct KeyValueView: View {
    var key: String
    var value: String
    var body: some View {
        HStack {
            Text(key)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding(8)
            .background(Color.white)
            .cornerRadius(8)
    }
}


#Preview {
    let authViewModel = AuthViewModel(authService: DefaultAuthService(baseURL: EnvironmentManager.current.baseURL))
    let viewModel = CoffeeViewModel(coffeeService: DefaultCoffeeService(baseURL: EnvironmentManager.current.baseURL))
    CoffeeCard(coffee: Coffee.MOCK_NOTHING_COFFEE)
        .environmentObject(authViewModel)
}
