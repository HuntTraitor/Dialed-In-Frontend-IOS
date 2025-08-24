//
//  ImageView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/25/25.
//

import SwiftUI
import UIKit

class ViewModel: ObservableObject {
    @Published var resource: UIImage?
    private let cache: URLCache = URLCache(
        memoryCapacity: 1024 * 1024 * 10,
        diskCapacity: 1024 * 1024 * 100
    )

    private var currentTask: Task<Void, Never>?

    func load(url: URL?) {
        guard let url = url else { return }

        // Cancel any existing load task
        currentTask?.cancel()

        currentTask = Task {
            let request = URLRequest(url: url)

            if let cachedResponse = cache.cachedResponse(for: request),
               let image = UIImage(data: cachedResponse.data) {
                await MainActor.run {
                    self.resource = image
                }
                return
            }

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("Invalid response")
                    return
                }

                if let image = await decodeImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedResponse, for: request)

                    await MainActor.run {
                        self.resource = image
                    }
                }
            } catch {
                if (error as? URLError)?.code != .cancelled {
                    print("Failed to load image: \(error)")
                } else {
                    print("⛔️ Image load cancelled")
                }
            }
        }
    }

    private func decodeImage(data: Data) async -> UIImage? {
        return await Task.detached {
            return UIImage(data: data)
        }.value
    }
}


struct ImageView: View {
    let url: URL?
    @StateObject private var viewModel = ViewModel()

    init(_ url: URL?) {
        self.url = url
    }

    var body: some View {
        Group {
            if let uiImage = viewModel.resource {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()  // Changed from scaledToFit
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            viewModel.load(url: url)
        }
        .onChange(of: url) { _, newValue in
            viewModel.load(url: newValue)
        }
    }
}

