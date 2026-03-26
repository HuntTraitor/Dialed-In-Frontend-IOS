//
//  MockGrinderService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

final class MockGrinderService: GrinderService {
    var isErrorThrown = false
    var noGrindersFound = false

    func fetchGrinders(withToken token: String) async throws -> [Grinder] {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if noGrindersFound {
            return []
        } else {
            return Grinder.MOCK_GRINDERS
        }
    }

    func postGrinder(input: GrinderInput, token: String) async throws -> Grinder {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return Grinder.MOCK_GRINDER
        }
    }

    func updateGrinder(input: GrinderInput, token: String) async throws -> Grinder {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else {
            return Grinder.MOCK_GRINDER
        }
    }

    func deleteGrinder(grinderId: Int, token: String) async throws -> Bool {
        if isErrorThrown {
            throw APIError.unknownError(error: DummyError.someError)
        } else if grinderId != Grinder.MOCK_GRINDER.id {
            throw APIError.invalidStatusCode(statusCode: 404)
        } else {
            return true
        }
    }
}
