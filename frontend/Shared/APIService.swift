//
//  APIService.swift
//  frontend
//
//  Created by Hunter Tratar on 12/13/24.
//

import Foundation

class BaseApiService {
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Request Building
    func authorizedRequest(
        path: String,
        method: String,
        token: String,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) -> URLRequest {
        
        let baseForPath = baseURL.appendingPathComponent(path)
        let resolvedURL: URL
        if let queryItems, !queryItems.isEmpty, var components = URLComponents(url: baseForPath, resolvingAgainstBaseURL: false) {
            components.queryItems = queryItems
            resolvedURL = components.url ?? baseForPath
        } else {
            resolvedURL = baseForPath
        }
        
        var request = URLRequest(url: resolvedURL)
        request.httpMethod = method
        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        return request
    }
    
    func encoded(_ input: some Encodable) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(input)
    }
    
    // MARK: - Performing Requests
    
    func perform(
        _ request: URLRequest,
        customValidation: ((Int) throws -> Void)? = nil,
        errorParser: (([String: Any]) throws -> Void)? = nil,
    ) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            try validate(response: response, data: data, customValidation: customValidation, errorParser: errorParser)
            return data
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    // MARK: - Validation
    
    private func validate(
        response: URLResponse,
        data: Data,
        customValidation: ((Int) throws -> Void)? = nil,
        errorParser: (([String: Any]) throws -> Void)? = nil
    ) throws {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "No valid HTTP response")
        }
        guard (200..<300).contains(http.statusCode) else {
            try customValidation?(http.statusCode)
            
            let json = (try? JSONSerialization.jsonObject(with: data) as? [String: Any]) ?? [:]
            
            try errorParser?(json)
            
            if let message = json["error"] as? String {
                throw APIError.custom(message: message)
            }
            throw APIError.invalidStatusCode(statusCode: http.statusCode)
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError.jsonParsingFailure(error: error)
        }
    }
    
}
