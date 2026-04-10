//
//  RecipeAnimationStepTracker.swift
//  DialedIn
//
//  Created by Codex on 4/9/26.
//

import SwiftUI

struct RecipeAnimationStep: Identifiable, Hashable {
    let id: Int
    let title: String
    let detailText: String?
}

enum RecipeAnimationLabels {
    private static let ordinals = [
        "First",
        "Second",
        "Third",
        "Fourth",
        "Fifth",
        "Sixth",
        "Seventh",
        "Eighth"
    ]

    static func ordinal(_ position: Int) -> String {
        guard position > 0 else {
            return "First"
        }

        if position <= ordinals.count {
            return ordinals[position - 1]
        }

        return "\(position)th"
    }
}

struct RecipeAnimationStepTracker: View {
    let steps: [RecipeAnimationStep]
    let activeIndex: Int
    var maxHeight: CGFloat? = nil

    private enum StepStatus {
        case completed
        case active
        case upcoming
    }

    private var accentColor: Color {
        Color("background").opacity(0.78)
    }

    private var trackerHeight: CGFloat {
        maxHeight ?? min(CGFloat(steps.count) * 68, 220)
    }

    var body: some View {
        VStack(spacing: 14) {
            Divider()
                .overlay(Color("background").opacity(0.12))

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                            row(for: step, status: status(for: index))
                                .id(step.id)
                        }
                    }
                    .padding(.vertical, 2)
                }
                .frame(height: trackerHeight)
                .onAppear {
                    scrollToActiveStep(with: proxy)
                }
                .onChange(of: activeIndex) { _ in
                    scrollToActiveStep(with: proxy)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private func status(for index: Int) -> StepStatus {
        if index < activeIndex {
            return .completed
        }

        if index == activeIndex {
            return .active
        }

        return .upcoming
    }

    private func scrollToActiveStep(with proxy: ScrollViewProxy) {
        guard steps.contains(where: { $0.id == activeIndex }) else {
            return
        }

        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.25)) {
                proxy.scrollTo(activeIndex, anchor: .center)
            }
        }
    }

    private func row(for step: RecipeAnimationStep, status: StepStatus) -> some View {
        HStack(spacing: 14) {
            marker(for: status)

            HStack(spacing: 0) {
                Text(step.title)
                    .font(.system(size: 17, weight: status == .active ? .semibold : .medium, design: .rounded))
                    .foregroundColor(.primary)

                if let detailText = step.detailText, !detailText.isEmpty {
                    Text(" - \(detailText)")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.8)

            Spacer(minLength: 0)

            trailingAccessory(for: status)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(status == .active ? Color("background").opacity(0.08) : .clear)
        )
    }

    @ViewBuilder
    private func marker(for status: StepStatus) -> some View {
        switch status {
        case .completed, .active:
            Circle()
                .fill(accentColor)
                .frame(width: 16, height: 16)
        case .upcoming:
            Circle()
                .stroke(Color.gray.opacity(0.45), lineWidth: 2)
                .frame(width: 16, height: 16)
        }
    }

    @ViewBuilder
    private func trailingAccessory(for status: StepStatus) -> some View {
        switch status {
        case .completed:
            Image(systemName: "checkmark")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(accentColor)
        case .active:
            Text("Active")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule(style: .continuous)
                        .fill(accentColor)
                )
        case .upcoming:
            EmptyView()
        }
    }
}
