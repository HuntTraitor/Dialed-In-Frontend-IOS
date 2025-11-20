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
                // Blurred / dimmed background
                VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                    .ignoresSafeArea()
                    .opacity(0.9)

                if let image = fullImage {
                    // Zoomable image
                    ZoomableImageView(image: image)
                        .ignoresSafeArea()
                } else if loadError {
                    Text("Failed to load image")
                        .foregroundColor(.white)
                } else {
                    ProgressView()
                        .task {
                            await loadFullImage()
                        }
                }

                // Close button
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
        }
        // Reset state when dismissed
        .onChange(of: isPresented) {
            if !isPresented {
                fullImage = nil
                isLoadingFull = false
                loadError = false
            }
        }
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
