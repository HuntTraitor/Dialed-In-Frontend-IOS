//
//  Environment.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

enum AppEnvironment {
    case development
    case production
    case test
    
    var baseURL: URL {
        switch self {
        case .development: return URL(string: "http://localhost:3000/v1/")!
        case .production: return URL(string: "https://dialedincafe.com/v1/")!
        case .test: return URL(string: "http://localhost:8080")!
        }
    }
}

enum EnvironmentManager {
    static var current: AppEnvironment {
        if CommandLine.arguments.contains("--use-dev-server") {
            print("Uses dev server")
            return .development
        } else if CommandLine.arguments.contains("--use-test-server") {
            print("Uses test server")
            return .test
        } else {
            print("Uses prod server")
            return .production
        }
    }
}

