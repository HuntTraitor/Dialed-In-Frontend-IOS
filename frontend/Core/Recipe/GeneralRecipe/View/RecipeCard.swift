//
//  RecipeCard.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct RecipeCard: View {
    @Binding var recipe: Recipe
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: RecipeViewModel
    @State private var showEditSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var recipeToDelete: Recipe?
    
    @ViewBuilder
    private var editSheetContent: some View {
        if let binding = $recipe.switchRecipeBinding {
            NavigationView {
                SwitchEditRecipeView(recipe: binding)
                    .navigationTitle("Edit Recipe")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        else if let binding = $recipe.v60RecipeBinding {
            NavigationView {
                V60EditRecipeView(recipe: binding)
                    .navigationTitle("Edit Recipe")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                RecipeCardLogoPlaceholder(method: recipe.method)

                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.primary)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        RecipeMethodPill(text: recipe.method.name)

                        Text(recipe.coffee?.info.name ?? "No coffee linked")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.primary.opacity(0.7))
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.bottom, 10)

            Divider()
                .frame(height: 1)
                .background(Color("background").opacity(0.55))
                .padding(.bottom, 10)

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 14) {
                    RecipeCardBrewVisualBlock(recipe: recipe)

                    VStack(spacing: 9) {
                        HStack(alignment: .top, spacing: 16) {
                            RecipeInlineMetric(label: "Dose", value: "\(recipe.gramsIn)g", centered: true)
                            RecipeInlineMetric(label: "Water", value: "\(recipe.waterAmount)ml", centered: true)
                        }
                        .frame(maxWidth: .infinity)

                        HStack(alignment: .top, spacing: 16) {
                            RecipeInlineMetric(label: "Ratio", value: recipe.ratioText, centered: true)
                            RecipeInlineMetric(label: "Temp", value: recipe.waterTempDisplay, centered: true)
                        }
                        .frame(maxWidth: .infinity)

                        RecipeInlineMetric(
                            label: "Grinder",
                            value: recipe.grinderDisplayName,
                            centered: true
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                VStack(spacing: 10) {
                    RecipeCardBrewVisualBlock(recipe: recipe)

                    HStack(alignment: .top, spacing: 16) {
                        RecipeInlineMetric(label: "Dose", value: "\(recipe.gramsIn)g", centered: true)
                        RecipeInlineMetric(label: "Water", value: "\(recipe.waterAmount)ml", centered: true)
                    }
                    .frame(maxWidth: .infinity)

                    HStack(alignment: .top, spacing: 16) {
                        RecipeInlineMetric(label: "Ratio", value: recipe.ratioText, centered: true)
                        RecipeInlineMetric(label: "Temp", value: recipe.waterTempDisplay, centered: true)
                    }
                    .frame(maxWidth: .infinity)

                    RecipeInlineMetric(
                        label: "Grinder",
                        value: recipe.grinderDisplayName,
                        centered: true
                    )
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.025), radius: 6, y: 2)
        .overlay(alignment: .topTrailing) {
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
                    recipeToDelete = recipe
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
                    .font(.system(size: 11, weight: .bold))
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color("background"))
                    .contentShape(Rectangle())
            }
            .padding(.top, 8)
            .padding(.trailing, 10)
        }
        .sheet(isPresented: $showEditSheet) {
            editSheetContent
        }
        .alert("Are you sure you want to delete this recipe?", isPresented: $showDeleteAlert, presenting: recipeToDelete) { recipe in
            Button("Yes", role: .destructive) {
                Task {
                    await viewModel.deleteRecipe(recipeId: recipe.id, token: authViewModel.token ?? "")
                    await viewModel.fetchRecipes(withToken: authViewModel.token ?? "")
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

private struct RecipeMethodPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(Color("background"))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule(style: .continuous)
                    .fill(Color("background").opacity(0.1))
            )
    }
}

private struct RecipeCardBrewVisualBlock: View {
    let recipe: Recipe

    var body: some View {
        VStack(spacing: 5) {
            RecipeCardMethodImage(recipe: recipe)

            Text("Time")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.primary.opacity(0.52))

            Text(recipe.brewTimeText)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(width: 82)
    }
}

private struct RecipeCardMethodImage: View {
    let recipe: Recipe

    var body: some View {
        Group {
            switch recipe {
            case .switchRecipe(let switchRecipe):
                SwitchRecipeViewImage(recipe: switchRecipe)
                    .scaleEffect(0.28)
            case .v60Recipe(let v60Recipe):
                V60RecipeViewImage(recipe: v60Recipe)
                    .scaleEffect(0.28)
            }
        }
        .frame(width: 76, height: 58)
    }
}

private struct RecipeInlineMetric: View {
    let label: String
    let value: String
    var centered: Bool = false

    var body: some View {
        VStack(alignment: centered ? .center : .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.primary.opacity(0.52))
                .lineLimit(1)

            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }
}

private struct RecipeCardLogoPlaceholder: View {
    let method: Method

    private var badgeText: String {
        switch method.type {
        case .harioSwitch:
            return "HS"
        case .v60:
            return "V60"
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(
                Color("background").opacity(0.08)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(
                        Color("background").opacity(0.16),
                        lineWidth: 1
                    )
            )
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.85))

                        Text(badgeText)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Color("background"))
                    }
                    .frame(width: 24, height: 24)

                    Spacer(minLength: 0)

                    Text("LOGO")
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .tracking(0.8)
                        .foregroundStyle(Color.primary.opacity(0.45))
                }
                .padding(9)
            }
            .frame(width: 46, height: 58)
            .accessibilityLabel("\(method.name) logo placeholder")
    }
}

private extension Recipe {
    var waterAmount: Int {
        switch self {
        case .switchRecipe(let recipe):
            let total = recipe.info.phases.reduce(0) { $0 + $1.amount }
            return total > 0 ? total : recipe.info.mlOut
        case .v60Recipe(let recipe):
            let total = recipe.info.phases.reduce(0) { $0 + $1.amount }
            return total > 0 ? total : recipe.info.mlOut
        }
    }

    var brewTimeText: String {
        let totalTime: Int

        switch self {
        case .switchRecipe(let recipe):
            totalTime = recipe.info.phases.reduce(0) { $0 + $1.time }
        case .v60Recipe(let recipe):
            totalTime = recipe.info.phases.reduce(0) { $0 + $1.time }
        }

        return totalTime > 0 ? Recipe.brewTimeString(from: totalTime) : "No timer"
    }

    var pourCount: Int {
        switch self {
        case .switchRecipe(let recipe):
            return recipe.info.phases.count
        case .v60Recipe(let recipe):
            return recipe.info.phases.count
        }
    }

    var waterTempDisplay: String {
        waterTemp.isEmpty ? "Not set" : waterTemp
    }

    var grinderDisplayName: String {
        grinder?.name ?? "Any grinder"
    }

    var ratioText: String {
        guard gramsIn > 0 else { return "-" }

        let ratio = Double(waterAmount) / Double(gramsIn)
        let roundedRatio = (ratio * 10).rounded() / 10

        if roundedRatio.truncatingRemainder(dividingBy: 1) == 0 {
            return "1:\(Int(roundedRatio))"
        }

        return String(format: "1:%.1f", roundedRatio)
    }

    private static func brewTimeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

}

extension Binding where Value == Recipe {
    var switchRecipeBinding: Binding<BaseRecipe<SwitchInfo>>? {
        guard case .switchRecipe = wrappedValue else { return nil }
        return Binding<BaseRecipe<SwitchInfo>>(
            get: {
                if case .switchRecipe(let sr) = self.wrappedValue {
                    return sr
                }
                fatalError("Unexpected enum case")
            },
            set: { newValue in
                self.wrappedValue = .switchRecipe(newValue)
            }
        )
    }
    
    var v60RecipeBinding: Binding<BaseRecipe<V60Info>>? {
        guard case .v60Recipe = wrappedValue else { return nil }
        return Binding<BaseRecipe<V60Info>>(
            get: {
                if case .v60Recipe(let vr) = self.wrappedValue {
                    return vr
                }
                fatalError("Unexpected enum case")
            },
            set: { newValue in
                self.wrappedValue = .v60Recipe(newValue)
            }
        )
    }
}


#Preview {
    @Previewable @State var recipe = Recipe.switchRecipe(BaseRecipe<SwitchInfo>.MOCK_SWITCH_RECIPE)
    PreviewWrapper {
        RecipeCard(recipe: $recipe)
    }
}
