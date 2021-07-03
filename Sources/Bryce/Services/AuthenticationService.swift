//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import Alamofire
import Foundation
import KeychainAccess
import Resolver

public final class AuthenticationService: Service {
    
    public enum Persistence {
        case memory
        case keychain
    }
    
    private enum Keys: String {
        
        case authentication = "Bryce.AuthenticationService.authentication"
    }
    
    private lazy var keychain: Keychain = { .init() }()
    
    var auth: Authentication?
    
    let persistence: Persistence
    
    public init(persistence: Persistence = .memory) {
        self.persistence = persistence
    }
    
    public func setup() {
        
        registerInterceptor()
        loadAuthFromKeychainIfNeeded()
    }
    
    public func teardown() {
        auth = nil
        saveAuthToKeychainIfNeeded()
    }
    
    fileprivate func registerInterceptor() {
        
        Bryce.intercept(using: AuthenticationInterceptor())
    }
    
    fileprivate func loadAuthFromKeychainIfNeeded() {
     
        guard case .keychain = persistence else { return }

        do {
            let decoder = Bryce.config.responseDecoder
            guard let data = try keychain.getData(Keys.authentication.rawValue) else { return }
            self.auth = try decoder.decode(Authentication.self, from: data)
        } catch {
            Bryce.log("Unable to load persisted authentication:", error)
        }
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

struct AuthenticationInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        if let auth = Bryce.authentication {
            
            var adaptedRequest = urlRequest
            
            switch auth {
            case .basic(let username, let password):
                adaptedRequest.headers.add(.authorization(username: username, password: password))
            case .bearer(let token, _):
                adaptedRequest.headers.add(.authorization(bearerToken: token))
            }
            
            return completion(.success(adaptedRequest))
            
        } else { return completion(.success(urlRequest)) }
    }
}
