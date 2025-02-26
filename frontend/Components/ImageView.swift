//
//  ImageView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 2/25/25.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var resource: UIImage?
    // 100 mb disk capacity
    let cache: URLCache = URLCache(
        memoryCapacity: 1024 * 1024 * 10,
        diskCapacity: 1024 * 1024 * 10
    )
    var cancellables: Set<AnyCancellable> = .init()
    
    func load(url: URL?) {
        guard let url = url else { return }
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        
        let session = URLSession(configuration: config)
        session.configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        if let cacheResponse = cache.cachedResponse(for: request) {
            self.resource = UIImage(data: cacheResponse.data)
            return
        }
        
        session
            .dataTaskPublisher(for: request)
            .tryMap({ (data: Data, response: URLResponse) in
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    return nil
                }
                guard !data.isEmpty else {
                    return nil
                }
                return UIImage(data: data)
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure:
                    print("error")
                default: break
                }
            } receiveValue: { resource in
                self.resource = resource
            }
            .store(in: &cancellables)
        
        
    }
}

struct ImageView : View {
    let url: URL?
    @StateObject var viewModel: ViewModel
    
    init(_ url: URL?) {
        self.url = url
        let viewModel = ViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.load(url: url)
    }
    
    var body: some View {
        if let uiImage = viewModel.resource {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
        }
    }
}

#Preview {
    ImageView(URL(string: "https://dialedin-dev.s3.us-east-2.amazonaws.com/coffees/9a9e81ceff071cea966814b65f2b4c1c7494c7d93a7e3082dff5c9d711dfc7dd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Checksum-Mode=ENABLED&X-Amz-Credential=AKIAT4ETZVPU7CPWNIGS%2F20250226%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250226T005713Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&x-id=GetObject&X-Amz-Signature=f32a5334b6b7230ec6bf12b1248ce2265ae5c1b8d3d8c2b5d808ae8fbdd86079"))
}


