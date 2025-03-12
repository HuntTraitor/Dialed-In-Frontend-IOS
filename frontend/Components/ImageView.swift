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
        memoryCapacity: 1024 * 1024 * 10, // 10 MB memory cache
        diskCapacity: 1024 * 1024 * 100  // 100 MB disk cache
    )

    func load(url: URL?) async {
        guard let url = url else { return }

        // Check cache first
        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                self.resource = image
            }
            return
        }


        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }

            // Decode image on a background thread
            if let image = await decodeImage(data: data) {
                // Cache the response
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: request)

                // Update the resource on the main thread
                await MainActor.run {
                    self.resource = image
                }
            }
        } catch {
            print("Failed to load image: \(error)")
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
                    .scaledToFit()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .task {
            await viewModel.load(url: url)
        }
        .onChange(of: url) { oldValue, newValue in
            viewModel.resource = nil
            Task {
                await viewModel.load(url: newValue)
            }
        }
    }
}
