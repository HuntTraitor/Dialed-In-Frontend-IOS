//
//  V60RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/14/25.
//

import SwiftUI

struct V60RecipeView: View {
    @State var recipe: BaseRecipe<V60Info>
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showCountdown = false
    @State private var showAnimation = false
    @State private var isShowingEditRecipeView: Bool = false

    private var sortedPhases: [V60Phase] {
        recipe.info.phases
    }

    private var totalTime: Int {
        sortedPhases.reduce(0) { $0 + $1.time }
    }

    private var headerSubtitle: String {
        recipe.method.name
    }

    private var metricItems: [RecipeMetricItem] {
        [
            RecipeMetricItem(value: "\(recipe.info.gramsIn)g", label: "Coffee"),
            RecipeMetricItem(value: "\(recipe.info.mlOut)g", label: "Water"),
            RecipeMetricItem(value: recipe.info.waterTemp, label: "Temp"),
            RecipeMetricItem(value: timeString(from: totalTime), label: "Time")
        ]
    }

    private var hasMetaSection: Bool {
        recipe.grinder != nil || recipe.coffee != nil || !(recipe.info.grindSize?.isEmpty ?? true)
    }

    private var hasGrindSize: Bool {
        !(recipe.info.grindSize?.isEmpty ?? true)
    }

    private var hasCoffee: Bool {
        recipe.coffee != nil
    }

    var body: some View {
        ZStack {
            mainContent
                .opacity(showAnimation ? 0 : 1)

            if showAnimation {
                VStack {
                    V60Animation(recipe: recipe, showAnimation: $showAnimation)
                        .padding(.top, 40)
                    Spacer()
                }
                .zIndex(2)
                .transition(.opacity)
            }

            if showCountdown {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(3)

                CountdownDialog(
                    seconds: 3,
                    onComplete: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showCountdown = false
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showAnimation = true
                            }
                        }
                    }
                )
                .zIndex(4)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showCountdown)
        .animation(.easeInOut(duration: 0.3), value: showAnimation)
        .toolbar(showAnimation ? .hidden : .visible, for: .tabBar)
        .toolbar(showAnimation ? .hidden : .visible, for: .navigationBar)
        .navigationBarBackButtonHidden(showAnimation)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingEditRecipeView = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color("background"))
                }
            }
        }
        .sheet(isPresented: $isShowingEditRecipeView) {
            NavigationStack {
                V60EditRecipeView(recipe: $recipe)
            }
        }
    }

    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 18) {
                    RecipeHeaderBlock(
                        title: recipe.info.name,
                        subtitle: headerSubtitle,
                        rating: nil
                    )

                    RecipeMetricsGrid(items: metricItems)

                    if hasMetaSection {
                        Divider()
                            .overlay(Color("background").opacity(0.12))

                        recipeMetaSection
                    }

                    Divider()
                        .overlay(Color("background").opacity(0.12))

                    brewHero

                    Divider()
                        .overlay(Color("background").opacity(0.12))

                    poursSection

                    Button {
                        showCountdown = true
                    } label: {
                        Text("Execute Recipe")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color("background"))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
        }
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
        )
    }

    private var brewHero: some View {
        VStack(spacing: 14) {
            VStack(spacing: 10) {
                V60RecipeViewImage(recipe: recipe)
                    .frame(maxWidth: .infinity)

                Text(timeString(from: totalTime))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(height: 290)
        }
    }

    private var recipeMetaSection: some View {
        VStack(spacing: 12) {
            if let grinder = recipe.grinder {
                metaRow(title: "Grinder") {
                    Text(grinder.name)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
            }

            if recipe.grinder != nil && (hasGrindSize || hasCoffee) {
                Divider()
                    .overlay(Color("background").opacity(0.10))
            }

            if let grindSize = recipe.info.grindSize, !grindSize.isEmpty {
                metaRow(title: "Grind Size") {
                    Text(grindSize)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
            }

            if hasGrindSize && hasCoffee {
                Divider()
                    .overlay(Color("background").opacity(0.10))
            }

            if let coffee = recipe.coffee {
                NavigationLink {
                    CoffeeCard(coffee: coffee)
                } label: {
                    metaRow(title: "Coffee") {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 10) {
                                Text(coffee.info.name)
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)

                                StarRatingView(rating: coffee.info.rating?.rawValue ?? .zero)
                            }

                            if let roaster = coffee.info.roaster, !roaster.isEmpty {
                                Text(roaster)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func metaRow<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)

                content()
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }

    private var poursSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(sortedPhases.enumerated()), id: \.offset) { index, phase in
                HStack(spacing: 14) {
                    Circle()
                        .fill(brownShade(for: index, total: sortedPhases.count).opacity(0.85))
                        .frame(width: 16, height: 16)

                    Text(pourDisplayText(for: index, phase: phase))
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer(minLength: 0)
                }
                .padding(.vertical, 6)
            }
        }
    }

    private func pourDisplayText(for index: Int, phase: V60Phase) -> String {
        "Pour \(index + 1) \u{2014} \(phase.amount)g \u{00B7} \(timeString(from: phase.time))"
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            V60RecipeView(recipe: BaseRecipe<V60Info>.MOCK_V60_RECIPE)
        }
    }
}
