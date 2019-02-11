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

public final class Bryce: NSObject {
    
    public static let shared = Bryce()
    
    public override init() {
        super.init()
        
        NetworkActivityLogger.shared.startLogging()
    }
    
    public func use(_ config: Configuration) { configuration = config }
    
    public func authenticate(_ auth: Authorization) { authorization = auth }
    
    public func logout() { authorization = nil }
    
    internal var configuration: Configuration! {
        
        didSet {
            
            NetworkActivityLogger.shared.level = configuration.logLevel            
            
            switch configuration!.securityPolicy {
            case .none: break
            case .certifcatePinning(let bundle):
                
                let policyManager = ServerTrustPolicyManager(policies: [configuration.baseUrl.host!: ServerTrustPolicy.pinPublicKeys(publicKeys: ServerTrustPolicy.publicKeys(in: bundle), validateCertificateChain: true, validateHost: true)])
                
                configuration.sessionManager = Alamofire.SessionManager(
                    configuration: .ephemeral,
                    serverTrustPolicyManager: policyManager)
            }
        }
    }
    
    @objc dynamic public var authorization: Authorization? {
        
        didSet {
            
            guard self.configuration != nil else { return }
            
            guard let authorization = authorization else { configuration.sessionManager.adapter = nil; return }
            
            configuration.sessionManager.adapter = AuthorizationAdapter(authorization: authorization)
        }
    }
}
