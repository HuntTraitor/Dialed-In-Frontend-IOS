//
//  Environment.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

enum AppEnvironment {
    case production
    case custom(URL)

    var baseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://dialedincafe.com/v1/")!
        case .custom(let url):
            return url
        }
    }
}


enum EnvironmentManager {
    static var current: AppEnvironment {
        #if DEBUG
//        return .custom(URL(string: "http://10.201.100.41:3000/v1/")!)
        return .custom(URL(string: "http://localhost:3000/v1/")!)
        #else
        return .production
        #endif
    }
}

