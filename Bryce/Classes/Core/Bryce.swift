//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger
import KeychainAccess

public typealias JSON = [String : Any]

public typealias BryceVoidHandler = () -> Void

public final class Bryce: NSObject {
    
    public static let shared = Bryce()
    
    private var authorizationKeychain: Keychain?
    
    private let authorizationKeychainKey = "bryce_authorization"
    
    public override init() {
        super.init()
    }

    public private(set) var configuration: Configuration! {
        
        didSet {
            
            NetworkActivityLogger.shared.level = configuration.logLevel
            
            NetworkActivityLogger.shared.startLogging()
            
            if let service = configuration.authorizationKeychainService {
                
                self.authorizationKeychain = Keychain(service: service)
                
                loadAuthorizationFromKeychain()
            }
            
            else { self.authorization = nil }
            
            switch configuration!.securityPolicy {
            case .none: break
            case .certifcatePinning(let bundle):
                
                let policyManager = ServerTrustPolicyManager(policies: [configuration.baseUrl.host!: ServerTrustPolicy.pinPublicKeys(publicKeys: ServerTrustPolicy.publicKeys(in: bundle), validateCertificateChain: true, validateHost: true)])
                
                let config = configuration.sessionManager.session.configuration
                
                configuration.sessionManager = Alamofire.SessionManager(
                    configuration: config,
                    serverTrustPolicyManager: policyManager)
            }
        }
    }
    
    public var authorization: Authorization? {
        
        get { return (configuration?.sessionManager.adapter as? AuthorizationMiddleware)?.authorization }
        
        set {
            
            let middleware = AuthorizationMiddleware(authorization: newValue)
            configuration?.sessionManager.adapter = middleware
            configuration?.sessionManager.retrier = middleware
         
            if let authorization = newValue {
                
                saveAuthorizationToKeychain(authorization)
            }
            else {
                configuration?.sessionManager.adapter = nil
            }
        }
    }
}

extension Bryce {
    
    public func use(_ config: Configuration) { configuration = config }
    
    public func logout() {
        
        EtagManager.clearEtagMap()
        
        removeAuthorizationFromKeychain()
        
        authorization = nil
    }
}

extension Bryce {
    
    private func loadAuthorizationFromKeychain() {
        
        guard let keychain = self.authorizationKeychain else { return }
        
        do {
            guard let data = try keychain.getData(authorizationKeychainKey) else { return }
            let authorization = try JSONDecoder().decode(Authorization.self, from: data)
            print("Loaded authorization from keychain.")
            self.authorization = authorization
        }
            
        catch { print("An error occurred loading persisted authorization from Keychain: \(error)") }
    }
    
    private func saveAuthorizationToKeychain(_ authorization: Authorization) {
        
        if let keychain = self.authorizationKeychain {
            
            do {
                
                let data = try JSONEncoder().encode(authorization)
                try keychain.set(data, key: authorizationKeychainKey)
                
                print("Persisted authorization in keychain.")
            }
                
            catch { print("An error occurred setting authorization to Keychain: \(error)") }
        }
    }
    
    private func removeAuthorizationFromKeychain() {
        
        if let keychain = self.authorizationKeychain {
            
            do {
                try keychain.remove(authorizationKeychainKey)
                
                print("Removed authorization from keychain")
            }
                
            catch { print("An error occurred removing authorization from Keychain: \(error)") }
        }
    }
}
