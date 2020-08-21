//
//  KeyChain.swift
//  ARCoreLocationLesson
//
//  Created by sogo on 2020/08/21.
//  Copyright © 2020 Sogo Nishihara. All rights reserved.
//

import Foundation
import KeychainAccess

class AccessToken {
    
    let keychain = Keychain()
    
    func saveToken(token: String) {
        
        keychain["AccessToken"] = token
        
    }
    
    func getToken() -> String {
        
        guard let token = keychain["AccessToken"] else { return "" }
        
        return token
        
    }
    
    func removeToken() {
        
        keychain["AccessToken"] = ""
        
    }
    
}

class RefreshToken {
    
    let keychain = Keychain()
    
    func saveToken(token: String) {
        
        keychain["RefreshToken"] = token
        
    }
    
    func getToken() -> String {
        
        guard let token = keychain["RefreshToken"] else { return "" }
        
        return token
        
    }
    
    func removeToken() {
        
        keychain["RefreshToken"] = ""
        
    }
    
}

class UserID {
    
    let keychain = Keychain()
    
    func saveID(id: String) {
        
        keychain["ID"] = id
        
    }
    
    func getID() -> String {
        
        guard let id = keychain["ID"] else { return "" }
        
        return id
        
    }
    
    func removeID() {
        
        keychain["ID"] = ""
        
    }
    
}
