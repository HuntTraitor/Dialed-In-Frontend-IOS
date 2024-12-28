//
//  KeyChainManager.swift
//  frontend
//
//  Created by Hunter Tratar on 12/28/24.
//

import SwiftUI
import SimpleKeychain

class KeychainManager: ObservableObject {
    private let simpleKeychain = SimpleKeychain()
    
    @Published var token: String?
    
    init() {
        loadToken()
    }
    
    func loadToken() {
        token = try? simpleKeychain.string(forKey: "token")
    }
    
    func saveToken(_ token: String) {
        try? simpleKeychain.set(token, forKey: "token")
        loadToken()
    }
    
    func deleteToken() {
        try? simpleKeychain.deleteItem(forKey: "token")
        loadToken()
    }
}
