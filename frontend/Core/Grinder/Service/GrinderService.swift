//
//  GrinderService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

protocol GrinderService {
    func fetchGrinders(withToken token: String) async throws -> [Grinder]
    func postGrinder(input: GrinderInput, token: String) async throws -> Grinder
    func deleteGrinder(grinderId: Int, token: String) async throws -> Bool
    func updateGrinder(input: GrinderInput, token: String) async throws -> Grinder
}

