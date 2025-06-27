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
    
    var baseURL: URL {
        switch self {
        case .development: return URL(string: "http://localhost:3000/v1/")!
        case .production: return URL(string: "http://dialedincafe.com/v1/")!
        }
    }
}

enum EnvironmentManager {
    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

