//
//  DefaultGrinderService.swift
//  DialedIn
//
//  Created by Hunter Tratar on 3/25/26.
//

import Foundation

final class DefaultGrinderService: GrinderService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetchGrinders(withToken token: String) async throws -> [Grinder] {
        let url = baseURL.appendingPathComponent("grinders")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Verification failed with response: \(json)")
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(MultiGrinderResponse.self, from: data)
                return decoded.grinders
            }  catch let decodingError as DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type \(type) at \(context.codingPath): \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value of type \(type) not found at \(context.codingPath): \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found at \(context.codingPath): \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted at \(context.codingPath): \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error: \(decodingError)")
                }
                throw APIError.jsonParsingFailure(error: decodingError)
            } catch {
                throw APIError.jsonParsingFailure(error: error)
            }

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func postGrinder(input: GrinderInput, token: String) async throws -> Grinder {
        let url = baseURL.appendingPathComponent("grinders")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        request.httpBody = try encoder.encode(input)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Upload failed with response: \(json)")
                    if let errorMessage = json["error"] as? String {
                        throw APIError.custom(message: errorMessage)
                    }
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(SingleGrinderResponse.self, from: data)
                return decoded.grinder
            } catch let decodingError as DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type \(type) at \(context.codingPath): \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value of type \(type) not found at \(context.codingPath): \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found at \(context.codingPath): \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted at \(context.codingPath): \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error: \(decodingError)")
                }
                throw APIError.jsonParsingFailure(error: decodingError)
            } catch {
                // For non-DecodingErrors (e.g., data issues)
                print("Unexpected error: \(error)")
                throw APIError.jsonParsingFailure(error: error)
            }

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func updateGrinder(input: GrinderInput, token: String) async throws -> Grinder {
        guard let id = input.id else {
            throw APIError.requestFailed(description: "Missing grinder ID for update.")
        }

        let url = baseURL.appendingPathComponent("grinders/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        request.httpBody = try encoder.encode(input)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Update failed with response: \(json)")
                    if let errorMessage = json["error"] as? String {
                        throw APIError.custom(message: errorMessage)
                    }
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(SingleGrinderResponse.self, from: data)
                return decoded.grinder
            } catch {
                throw APIError.jsonParsingFailure(error: error)
            }

        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    func deleteGrinder(grinderId: Int, token: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("grinders/\(grinderId)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(description: "No valid HTTP response")
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Delete failed with response: \(json)")
                    if let errorMessage = json["error"] as? String {
                        throw APIError.custom(message: errorMessage)
                    }
                }
                throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            }

            _ = try? JSONDecoder().decode(DeleteGrinderResponse.self, from: data)
            return true
            
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknownError(error: error)
        }
    }
    
    
    
}

