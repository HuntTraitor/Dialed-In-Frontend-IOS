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
    }
}

#Preview {
    ImageView(URL(string: "https://dialedin-dev.s3.us-east-2.amazonaws.com/coffees/9a9e81ceff071cea966814b65f2b4c1c7494c7d93a7e3082dff5c9d711dfc7dd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Checksum-Mode=ENABLED&X-Amz-Credential=AKIAT4ETZVPU7CPWNIGS%2F20250226%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250226T005713Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&x-id=GetObject&X-Amz-Signature=f32a5334b6b7230ec6bf12b1248ce2265ae5c1b8d3d8c2b5d808ae8fbdd86079"))
}
