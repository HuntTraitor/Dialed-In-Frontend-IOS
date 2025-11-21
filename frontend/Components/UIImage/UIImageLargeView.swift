//
//  UIImageLargeView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 11/20/25.
//

import SwiftUI

struct URLImageLargeView: View {
    let url: URL
    var thumbnailHeight: CGFloat = 150

    @State private var isPresented = false
    @State private var fullImage: UIImage?
    @State private var isLoadingFull = false
    @State private var loadError: Bool = false

    // For swipe-down-to-close
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        Button {
            isPresented = true
        } label: {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: thumbnailHeight)
                        .clipped()
                        .cornerRadius(12)
                case .failure(_):
                    Color.gray
                        .frame(height: thumbnailHeight)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white.opacity(0.7))
                        )
                case .empty:
                    ProgressView()
                        .frame(height: thumbnailHeight)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $isPresented) {
            ZStack {
                // Dimmed / blurred background (fades slightly as you drag)
                VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                    .ignoresSafeArea()
                    .opacity(backgroundOpacity)

                if let image = fullImage {
                    ZoomableImageView(image: image)
                        .ignoresSafeArea()
                        .offset(y: dragOffset)
                        .scaleEffect(imageScale)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
                } else if loadError {
                    Text("Failed to load image")
                        .foregroundColor(.white)
                } else {
                    ProgressView()
                        .task {
                            await loadFullImage()
                        }
                }

                VStack {
                    HStack {
                        Spacer()
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.9))
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = max(value.translation.height, 0)
                    }
                    .onEnded { value in
                        let translation = value.translation.height
                        let velocity = value.predictedEndTranslation.height

                        let shouldDismiss = translation > 120 || velocity > 300

                        if shouldDismiss {
                            isPresented = false
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .onChange(of: isPresented) {
            if !isPresented {
                fullImage = nil
                isLoadingFull = false
                loadError = false
                dragOffset = 0
            }
        }
    }

    private var backgroundOpacity: Double {
        let maxFade: CGFloat = 0.4
        let progress = min(dragOffset / 300, 1)
        return 0.9 - Double(progress * maxFade)
    }

    private var imageScale: CGFloat {
        let maxScaleReduction: CGFloat = 0.08
        let progress = min(dragOffset / 300, 1)
        return 1.0 - (progress * maxScaleReduction)
    }

    private func loadFullImage() async {
        guard !isLoadingFull, fullImage == nil else { return }
        isLoadingFull = true
        loadError = false

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let img = UIImage(data: data) {
                await MainActor.run {
                    self.fullImage = img
                    self.isLoadingFull = false
                }
            } else {
                await MainActor.run {
                    self.loadError = true
                    self.isLoadingFull = false
                }
            }
        } catch {
            await MainActor.run {
                self.loadError = true
                self.isLoadingFull = false
            }
        }
    }
}
