//
//  DefaultGrinderService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import Foundation

final class DefaultGrinderService: BaseApiService, GrinderService {
    
    func fetchGrinders(withToken token: String) async throws -> [Grinder] {
        let request = authorizedRequest(path: "grinders", method: "GET", token: token)
        let data = try await perform(request)
        return try decode(MultiGrinderResponse.self, from: data).grinders
    }
    
    func postGrinder(input: GrinderInput, token: String) async throws -> Grinder {
        let request = authorizedRequest(path: "grinders", method: "POST", token: token, body: try encoded(input))
        let data = try await perform(request)
        return try decode(SingleGrinderResponse.self, from: data).grinder
    }
    
    func updateGrinder(input: GrinderInput, token: String) async throws -> Grinder {
        guard let id = input.id else {
            throw APIError.requestFailed(description: "Missing grinder ID for update")
        }
        struct UpdateGrinderPayload: Encodable { let name: String }
        let payload = UpdateGrinderPayload(name: input.name)
        let request = authorizedRequest(path: "grinders/\(id)", method: "PATCH", token: token, body: try encoded(payload))
        let data = try await perform(request)
        return try decode(SingleGrinderResponse.self, from: data).grinder
    }
    
    func deleteGrinder(grinderId: Int, token: String) async throws -> Bool {
        let request = authorizedRequest(path: "grinders/\(grinderId)", method: "DELETE", token: token)
        _ = try await perform(request)
        return true
    }
    
    
}
