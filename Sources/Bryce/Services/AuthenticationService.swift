//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import Foundation
import Resolver
import KeychainAccess

public final class AuthenticationService: Service {
    
    public enum Persistence {
        case memory
        case keychain
    }
    
    private enum Keys: String {
        
        case authentication = "Bryce.AuthenticationService.authentication"
    }
    
    private lazy var keychain: Keychain = { .init() }()
    
    var auth: Authentication? {
        didSet {
            let config = Bryce.config
            var headers = config.globalHeaders
            let key = Authentication.headerKey
            if let auth = self.auth {
                headers[key] = auth.headerValue
            } else {
                headers[key] = nil
            }
            config.globalHeaders = headers
        }
    }
    
    private let persistence: Persistence
    
    public init(persistence: Persistence = .memory) {
        self.persistence = persistence
    }
    
    public func setup() {
        
        guard case .keychain = persistence else { return }

        do {
            let decoder = Bryce.config.responseDecoder
            guard let data = try keychain.getData(Keys.authentication.rawValue) else { return }
            self.auth = try decoder.decode(Authentication.self, from: data)
        } catch {
            Bryce.log("Unable to load persisted authentication:", error)
        }
    }
    
    public func teardown() {
        auth = nil
        saveAuthToKeychainIfNeeded()
    }
    
    fileprivate func saveAuthToKeychainIfNeeded() {
        
        guard case .keychain = persistence else { return }
        
        if let auth = auth {
            do {
                let encoder = Bryce.config.requestEncoder
                let data = try encoder.encode(auth)
                try keychain.set(data, key: Keys.authentication.rawValue)
            } catch {
                Bryce.log("Unable to persist authentication:", error)
            }
        } else {
            do {
                try keychain.remove(Keys.authentication.rawValue)
            } catch {
                Bryce.log("Unable to remove authentication:", error)
            }
        }
    }
}

extension Bryce {
    
    static var authService: AuthenticationService? { Resolver.bryce.optional() }
    
    public static var authentication: Authentication? { authService?.auth }
    
    public static func setAuthentication(_ auth: Authentication?) {
        
        guard let authService = authService else {
            Bryce.log("Attempted to set authentication, but AuthenticationService hasn't been registered. Register using Bryce.use(AuthenticationService()).")
            return
        }
        
        authService.auth = auth
        authService.saveAuthToKeychainIfNeeded()
    }
}
