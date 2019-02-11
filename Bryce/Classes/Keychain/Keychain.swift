//
//  Keychain.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/10/19.
//

import Foundation
import Alamofire
import KeychainAccess

extension Authorization {
    
    fileprivate static let keychainKey = "bryce_authorization"
    
    func persistToKeychain(_ keychain: Keychain) {
        
        do {
            
            let data = try JSONEncoder().encode(self)
            try keychain.set(data, key: Authorization.keychainKey)
            
            print("Persisted authorization in keychain.")
        }
            
        catch { print("An error occurred setting authorization to Keychain: \(error)") }
    }
}

extension Bryce {
    
    public static var authorizationObserver: NSKeyValueObservation!
    
    fileprivate static var keychain: Keychain!
    
    private func loadPersistedAuthorization() {
        
        do {
            guard let data = try Bryce.keychain.getData(Authorization.keychainKey) else { return }
            let authorization = try JSONDecoder().decode(Authorization.self, from: data)
            self.authorization = authorization
            
            print("Loaded authorization from keychain.")
        }
            
        catch { print("An error occurred loading persisted authorization from Keychain: \(error)") }
    }
    
    public func usePersistedAuthorization(service: String, accessGroup: String? = nil) {
        
        if let accessGroup = accessGroup { Bryce.keychain = Keychain(service: service, accessGroup: accessGroup) }
            
        else { Bryce.keychain = Keychain(service: service) }
        
        loadPersistedAuthorization()
                
        Bryce.authorizationObserver = observe(\.authorization, options: [.new]) { bryceInstance, change in

            if let authorization = bryceInstance.authorization { authorization.persistToKeychain(Bryce.keychain) }

            else {

                do {
                    try Bryce.keychain.remove(Authorization.keychainKey)

                    print("Removed authorization from keychain")
                }

                catch { print("An error occurred removing authorization from Keychain: \(error)") }
            }
        }
    }
}
