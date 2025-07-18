//
//  DefaultMethodService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class DefaultMethodService: MethodService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // Fetch methods from the API endpoint
    func fetchMethods() async throws -> [Method] {
        let url = baseURL.appendingPathComponent("methods")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "Invalid response")
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(MethodResponse.self, from: data).methods
            } catch {
                print("Decoding failed with error:", error)
                throw APIError.jsonParsingFailure(error: error)
            }
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
}


