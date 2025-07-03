//
//  APIError.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case jsonParsingFailure(error: Error)
    case unknownError(error: Error)
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .requestFailed(let description):
            return description
        case .invalidStatusCode(let code):
            return "Request failed with status code \(code)."
        case .jsonParsingFailure(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .unknownError(let error):
            return "Unexpected error: \(error.localizedDescription)"
        case .custom(let message):
            return message
        }
    }
}

enum DummyError: Error {
    case someError
}

