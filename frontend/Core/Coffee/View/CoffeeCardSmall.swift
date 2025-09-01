//
//  CoffeeCardSmall.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/15/25.
//

import SwiftUI

struct CoffeeCardSmall: View {
    @State var coffee: Coffee
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CoffeeViewModel
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @State private var showDeleteAlert = false
    @State private var coffeeToDelete: Coffee?
    @State private var showEditSheet = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(coffee.info.name)
                    .padding(.leading, 30)
                    .lineLimit(1)
                
                Spacer()
                
                StarRatingView(rating: coffee.info.rating?.rawValue ?? .zero)
                    .padding(.trailing, 10)
                
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                    }
                    
                    
                    Button(role: .destructive) {
                        coffeeToDelete = coffee
                        showDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .frame(width: 44, height: 44)
                        .padding(.trailing, 20)
                        .foregroundColor(Color("background"))
                }
            }
            
            
            Divider()
                .frame(height: 1)
                .background(Color("background"))
                .padding(.horizontal, 20)
            
            HStack(alignment: .top, spacing: 16) {
                // Image on the left
                if let imgString = coffee.info.img, !imgString.isEmpty, let url = URL(string: imgString) {
                    ZStack {
                        ImageView(url)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.leading, 20)
                    }
                    .frame(width: 100, height: 100)
                } else {
                    Color.clear
                        .frame(width: 50, height: 100)
                }
                
                // First column of text
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(title: "Roaster", value: coffee.info.roaster ?? "-")
                    InfoRow(title: "Region", value: coffee.info.region ?? "-")
                    InfoRow(title: "Process", value: coffee.info.process ?? "-")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Second column of text
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(
                        title: "Roast Level",
                        value: (coffee.info.roastLevel == .unknown || coffee.info.roastLevel == nil)
                            ? "-"
                            : coffee.info.roastLevel!.displayName
                    )

                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Decaff?")
                            .font(.caption)
                            .foregroundColor(.gray)
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
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Tasting Notes")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text((coffee.info.tastingNotes?.map { $0.rawValue }.joined(separator: ", ")) ?? "-")
                            .font(.system(size: 13))
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
        }
        .sheet(isPresented: $showEditSheet) {
            EditCoffeeView(coffee: $coffee)
        }
        .alert("Are you sure you want to delete?", isPresented: $showDeleteAlert, presenting: coffeeToDelete) { coffee in
            Button("Yes", role: .destructive) {
                Task {
                    await viewModel.deleteCoffee(coffeeId: coffee.id, token: authViewModel.token ?? "")
                    await recipeViewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 13))
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            CoffeeCardSmall(coffee: Coffee.MOCK_COFFEE)
        }
    }
}
