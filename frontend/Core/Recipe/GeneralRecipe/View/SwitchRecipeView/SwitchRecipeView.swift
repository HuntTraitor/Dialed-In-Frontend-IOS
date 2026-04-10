//
//  RecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/15/25.
//

import SwiftUI

struct SwitchRecipeView: View {
    @State var recipe: BaseRecipe<SwitchInfo>
    @EnvironmentObject var coffeeViewModel: CoffeeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showCountdown = false
    @State private var showAnimation = false
    @State private var isShowingEditRecipeView: Bool = false

    private var sortedPhases: [SwitchPhase] {
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
                    SwitchAnimation(recipe: recipe, showAnimation: $showAnimation)
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
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCountdown = false
                            showAnimation = true
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
                SwitchEditRecipeView(recipe: $recipe)
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

                    phasesSection

                    Button {
                        showCountdown = true
                    } label: {
                        Text("Begin Brewing")
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
                SwitchRecipeViewImage(recipe: recipe)
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

    private var phasesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(sortedPhases.enumerated()), id: \.offset) { index, phase in
                HStack(spacing: 14) {
                    Circle()
                        .fill(phaseMarkerColor(for: index))
                        .frame(width: 16, height: 16)
                        .overlay {
                            Circle()
                                .stroke(phaseMarkerStrokeColor(for: index), lineWidth: phaseMarkerStrokeWidth(for: index))
                        }

                    Text(phaseDisplayText(for: index, phase: phase))
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

    private func phaseTitle(for index: Int, phase: SwitchPhase) -> String {
        switch index {
        case 0:
            return "Bloom"
        case 1:
            return phase.open ? "Second Pour" : "Immersion"
        case sortedPhases.count - 1:
            return phase.amount == 0 ? "Drawdown" : "Finish"
        default:
            return "Phase \(index + 1)"
        }
    }

    private func phaseDisplayText(for index: Int, phase: SwitchPhase) -> String {
        "\(phaseTitle(for: index, phase: phase)) \u{2014} \(phase.amount)g \u{00B7} \(timeString(from: phase.time))"
    }

    private func phaseMarkerColor(for index: Int) -> Color {
        brownShade(for: index, total: sortedPhases.count).opacity(0.85)
    }

    private func phaseMarkerStrokeColor(for index: Int) -> Color {
        .clear
    }

    private func phaseMarkerStrokeWidth(for index: Int) -> CGFloat {
        0
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            SwitchRecipeView(recipe: BaseRecipe<SwitchInfo>.MOCK_SWITCH_RECIPE)
        }
    }
}
