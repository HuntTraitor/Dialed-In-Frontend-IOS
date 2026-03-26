//
//  GrinderViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import Foundation

@MainActor
class GrinderViewModel: ObservableObject {
    @Published var grinders: [Grinder] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let grinderService: GrinderService

    init(grinderService: GrinderService) {
        self.grinderService = grinderService
    }

    func fetchGrinders(withToken token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let grinders = try await grinderService.fetchGrinders(withToken: token)
            self.grinders = grinders
        } catch {
            errorMessage = "Failed to fetch grinders: \(error.localizedDescription)"
        }
    }

    func postGrinder(input: GrinderInput, token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            _ = try await grinderService.postGrinder(input: input, token: token)
            await fetchGrinders(withToken: token)
        } catch {
            errorMessage = "Failed to post grinder: \(error.localizedDescription)"
        }
    }

    func deleteGrinder(grinderId: Int, token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let deleted = try await grinderService.deleteGrinder(grinderId: grinderId, token: token)
            if deleted {
                await fetchGrinders(withToken: token)
            }
        } catch {
            errorMessage = "Failed to delete grinder: \(error.localizedDescription)"
        }
    }

    func updateGrinder(input: GrinderInput, token: String) async -> Grinder? {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let grinder = try await grinderService.updateGrinder(input: input, token: token)
            await fetchGrinders(withToken: token)
            return grinder
        } catch {
            errorMessage = "Failed to update grinder: \(error.localizedDescription)"
            return nil
        }
    }

    func isValidName(name: String) -> Bool {
        return !name.isEmpty && name.count <= 500
    }
}
