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
        let env = ProcessInfo.processInfo.environment

        if let rawURL = env["-base-url"], let url = URL(string: rawURL) {
            print("Using custom base URL: \(rawURL)")
            return .custom(url)
        }
        print("Using production URL")
        return .production
    }
}

