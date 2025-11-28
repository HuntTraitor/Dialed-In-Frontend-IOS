//
//  CommonRecipeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/24/25.
//

import SwiftUI

struct CommonRecipeView: View {
    var recipe: Recipe
    var title: String
    var description: String
    var link: String

    /// Called when a recipe is successfully created
    var onRecipeCreated: (() -> Void)? = nil

    @State private var isShowingCreateRecipeView: Bool = false
    @State private var isExpanded: Bool = false

    private var linkURL: URL? {
        URL(string: link)
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 16) {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 12)

                    if let linkURL {
                        Link(destination: linkURL) {
                            HStack(spacing: 12) {
                                linkThumbnail

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("View full recipe")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)

                                    Text(linkURL.host ?? link)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }

                                Spacer()

                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.systemBackground).opacity(0.6))
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        isShowingCreateRecipeView = true
                    } label: {
                        HStack {
                            Text("Add recipe")
                                .fontWeight(.semibold)
                            Image(systemName: "plus")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 180, height: 32)
                    }
                    .background(Color("background"))
                    .cornerRadius(30)
                    .padding(.top, 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 6)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
        .padding(.horizontal)
        .animation(.spring(response: 0.3, dampingFraction: 0.9), value: isExpanded)
        .sheet(isPresented: $isShowingCreateRecipeView) {
            NavigationStack {
                createRecipeSheet
            }
        }
    }

    // MARK: - Sheet content

    @ViewBuilder
    private var createRecipeSheet: some View {
        switch recipe {
        case .switchRecipe(let switchRecipe):
            SwitchCreateRecipeView(
                existingRecipe: switchRecipe,
                onSuccess: handleRecipeCreated
            )

        case .v60Recipe(let v60Recipe):
            V60CreateRecipeView(
                existingRecipe: v60Recipe,
                onSuccess: handleRecipeCreated
            )
        }
    }

    private func handleRecipeCreated() {
        // Close the sheet and notify parent
        isShowingCreateRecipeView = false
        onRecipeCreated?()
    }

    // MARK: - Thumbnail

    @ViewBuilder
    private var linkThumbnail: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.gray.opacity(0.15))
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: "link")
                    .font(.headline)
                    .foregroundColor(.secondary)
            )
    }
}


#Preview {
    PreviewWrapper {
        CommonRecipeView(
            recipe: .switchRecipe(SwitchRecipe.MOCK_SWITCH_RECIPE),
            title: "Coffee Chronicler Hario Switch",
            description: "This Hario Switch recipe uses a simple two-pour hybrid technique that combines pour-over clarity with immersion body. The first open-valve burst pour extracts bright, fruity notes, while the second pour and closed-switch steep create deeper sweetness and consistency. It’s easy to memorize, flexible across doses and ratios, and works well with a wide range of beans and grinders. Expect a lively, fruit-forward cup with a smooth, rounded finish.",
            link: "https://www.youtube.com/watch?v=68ZOXrXbVHc"
        )
    }
}
