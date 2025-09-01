//
//  APIService.swift
//  frontend
//
//  Created by Hunter Tratar on 12/13/24.
//

import Foundation

struct APIResponse: Decodable {
    let success: Bool
    let message: String
}

// Send a post request with a specific body
func Post(to urlString: String, with body: [String: Any], withHeaders headers: [String: Any]) async throws -> [String: Any] {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    for (key, value) in headers {
        request.setValue("\(value)", forHTTPHeaderField: key)
    }
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, _) = try await URLSession.shared.data(for: request)

    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw URLError(.cannotParseResponse)
    }
    return json
}

// Send a get request with any specific headers
func Get(to urlString: String, with headers: [String: Any]) async throws -> [String: Any] {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    for (key, value) in headers {
        request.setValue("\(value)", forHTTPHeaderField: key)
    }
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw URLError(.cannotParseResponse)
    }
    return json
}

func Delete(to urlString: String, with headers: [String: Any]) async throws -> [String: Any] {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    for (key, value) in headers {
        request.setValue("\(value)", forHTTPHeaderField: key)
    }
    
    let (data, _) = try await URLSession.shared.data(for: request)
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        throw URLError(.cannotParseResponse)
    }
    return json
}

