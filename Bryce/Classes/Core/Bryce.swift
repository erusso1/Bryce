//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

public typealias JSON = [String : Any]

public typealias BryceVoidHandler = () -> Void

public final class Bryce: NSObject {
    
    public static let shared = Bryce()
        
    public override init() {
        super.init()
    }

    public private(set) var configuration: Configuration!
}

extension Bryce {
    
    public func use(_ config: Configuration) {
        
        configuration = config
        
        NetworkActivityLogger.shared.level = configuration.logLevel
        
        if configuration.logLevel != .off {
            NetworkActivityLogger.shared.startLogging()
        }
    }
    
    public func teardown() {
        
        EtagManager.clearEtagMap()
    }
}

extension Bryce {
    
    internal func log(prefix: String = "[Bryce]", _ level: LogLevel, _ items: Any...) {
        
        if let logger = configuration.customLogger {
            logger.log(prefix, level, items)
        }
        else {
            print("\(prefix) \(items)")
        }
    }
}

//extension Bryce {
//
//    private func loadAuthorizationFromKeychain() -> Authorization? {
//
//        guard let keychain = self.authorizationKeychain else { return nil }
//
//        do {
//            guard let data = try keychain.getData(authorizationKeychainKey) else { return nil }
//            let authorization = try JSONDecoder().decode(Authorization.self, from: data)
//            print("***********************************************")
//            print("")
//            print("Bryce loaded authorization from keychain.")
//            if let expiration = authorization.expiration { print("Authorization expiry: \(expiration)") }
//            print("")
//            print("***********************************************")
//            print("")
//            return authorization
//        }
//
//        catch { log(.error, "An error occurred loading persisted authorization from Keychain: \(error)"); return nil }
//    }
//
//    private func saveAuthorizationToKeychain(_ authorization: Authorization) {
//
//        if let keychain = self.authorizationKeychain {
//
//            do {
//
//                let data = try JSONEncoder().encode(authorization)
//                try keychain.set(data, key: authorizationKeychainKey)
//
//                print("***********************************************")
//                print("")
//                print("Bryce persisted authorization to keychain.")
//                if let expiration = authorization.expiration { print("Authorization expiry: \(expiration)") }
//                print("")
//                print("***********************************************")
//                print("")
//            }
//
//            catch { log(.error, "An error occurred setting authorization to Keychain: \(error)") }
//        }
//    }
//
//    private func removeAuthorizationFromKeychain() {
//
//        if let keychain = self.authorizationKeychain {
//
//            do {
//                try keychain.remove(authorizationKeychainKey)
//
//                print("***********************************************")
//                print("")
//                print("Bryce removed authorization from keychain.")
//                print("")
//                print("***********************************************")
//                print("")
//            }
//
//            catch { print("An error occurred removing authorization from Keychain: \(error)") }
//        }
//    }
//}
