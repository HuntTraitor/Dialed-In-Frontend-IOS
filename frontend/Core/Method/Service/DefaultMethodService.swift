//
//  DefaultMethodService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

import Foundation

final class DefaultMethodService: BaseApiService, MethodService {
    
    func fetchMethods() async throws -> [Method] {
        let request = authorizedRequest(path: "methods", method: "GET", token: "")
        let data = try await perform(request)
        return try decode(MethodResponse.self, from: data).methods
    }
}


