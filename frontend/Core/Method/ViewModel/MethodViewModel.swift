//
//  MethodViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/26/25.
//

import Foundation

class MethodViewModel: ObservableObject {
    @Published var methods: [Method] = []
    
    func fetchMethods() async {
        do {
            let endpoint = "http://localhost:3000/v1/methods"
            let result = try await Get(to: endpoint, with: [:])
            
            guard let methodDicts = result["methods"] as? [[String: Any]] else {
                throw CustomError.methodError(message: "Error when parsing methods")
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: methodDicts, options: [])
            let methods = try JSONDecoder().decode([Method].self, from: jsonData)
            
            await MainActor.run {
                self.methods = methods
            }
            
        } catch {
            print("Error fetching methods: \(error)")
        }
    }
}
