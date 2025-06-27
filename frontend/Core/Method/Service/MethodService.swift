//
//  MethodService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 6/26/25.
//

protocol MethodService {
    func fetchMethods() async throws -> [Method]
}

