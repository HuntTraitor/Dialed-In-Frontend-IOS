//
//  MethodViewModel.swift
//  DialedIn
//
//  Created by Hunter Tratar on 1/26/25.
//

import Foundation

@MainActor
class MethodViewModel: ObservableObject {
    @Published var methods: [Method] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let methodService: MethodService
    
    init(methodService: MethodService) {
        self.methodService = methodService
    }
    
    func fetchMethods() async {
        isLoading = true
        errorMessage = nil
        do {
            methods = try await methodService.fetchMethods()
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

