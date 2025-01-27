//
//  MethodViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/26/25.
//

import Foundation

class MethodViewModel: ObservableObject {
    init() {
        
    }
    
    func getMethods() async throws -> [Method] {
        let endpoint = "http://localhost:3000/v1/methods"
        let result = try await Get(to: endpoint, with: [:])
        guard let methodDicts = result["methods"] as? [[String: Any]] else {
            throw CustomError.methodError(message: "Error when parsing methods")
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: methodDicts, options: [])
        let methods = try JSONDecoder().decode([Method].self, from: jsonData)
        return methods
    }
}
