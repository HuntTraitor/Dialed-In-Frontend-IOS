//
//  APIError.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

enum APIError: Error {
    case invalidData
    case jsonParsingFailure(error: Error)
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData:
            return "Invalid data received from server."
        case .jsonParsingFailure(error: let error):
            return "Failed to parse JSON: \(error.localizedDescription)"
        case .requestFailed(description: let description):
            return "Request failed: \(description)"
        case .invalidStatusCode(statusCode: let code):
            return "Invalid status code: \(code)"
        case .unknownError(error: let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

// Conform to LocalizedError for better error messages
extension APIError: LocalizedError {
    var errorDescription: String? {
        return customDescription
    }
}

enum DummyError: Error {
    case someError
}

