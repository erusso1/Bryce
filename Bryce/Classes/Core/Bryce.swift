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
            
            if let service = configuration.authorizationKeychainService { self.authorizationKeychain = Keychain(service: service) }
                        
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
    
    private var _authorization: Authorization? {
        
        didSet {
            
            if let auth = self._authorization {
                
                let middleware = AuthorizationMiddleware(authorization: auth)
                configuration?.sessionManager.adapter = middleware
                configuration?.sessionManager.retrier = middleware
            }
            
            else {
                configuration?.sessionManager.adapter = nil
                configuration?.sessionManager.retrier = nil
            }
        }
    }
    
    public var authorization: Authorization? {
        
        get {
            
            if let auth = self._authorization {
                return auth
            }
            
            else if let auth = self.loadAuthorizationFromKeychain() {
                self._authorization = auth; return auth
            }
            
            else {
                return nil
            }
        }
        
        set {

            if let auth = newValue {
                saveAuthorizationToKeychain(auth)
            }
            
            else {
                removeAuthorizationFromKeychain()
            }
            
            self._authorization = newValue
        }
    }
}

extension Bryce {
    
    public func use(_ config: Configuration) { configuration = config }
    
    internal func log(_ level: LogLevel, _ items: Any...) {
        
        if let logger = configuration.customLogger {
            logger.log(level, items)
        }
        else {
            print(items)
        }
    }
    
    public func logout() {
        
        EtagManager.clearEtagMap()
                
        authorization = nil
    }
}

extension Bryce {
    
    private func loadAuthorizationFromKeychain() -> Authorization? {
        
        guard let keychain = self.authorizationKeychain else { return nil }
        
        do {
            guard let data = try keychain.getData(authorizationKeychainKey) else { return nil }
            let authorization = try JSONDecoder().decode(Authorization.self, from: data)
            print("***********************************************")
            print("")
            print("Bryce loaded authorization from keychain.")
            if let expiration = authorization.expiration { print("Authorization expiry: \(expiration)") }
            print("")
            print("***********************************************")
            print("")
            return authorization
        }
            
        catch { print("An error occurred loading persisted authorization from Keychain: \(error)"); return nil }
    }
    
    private func saveAuthorizationToKeychain(_ authorization: Authorization) {
        
        if let keychain = self.authorizationKeychain {
            
            do {
                
                let data = try JSONEncoder().encode(authorization)
                try keychain.set(data, key: authorizationKeychainKey)

                print("***********************************************")
                print("")
                print("Bryce persisted authorization to keychain.")
                if let expiration = authorization.expiration { print("Authorization expiry: \(expiration)") }
                print("")
                print("***********************************************")
                print("")
            }
                
            catch { print("An error occurred setting authorization to Keychain: \(error)") }
        }
    }
    
    private func removeAuthorizationFromKeychain() {
        
        if let keychain = self.authorizationKeychain {
            
            do {
                try keychain.remove(authorizationKeychainKey)
                
                print("***********************************************")
                print("")
                print("Bryce removed authorization from keychain.")
                print("")
                print("***********************************************")
                print("")                
            }
                
            catch { print("An error occurred removing authorization from Keychain: \(error)") }
        }
    }
}
