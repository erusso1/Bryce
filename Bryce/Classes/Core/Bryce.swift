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
    
    private var serverTrustPolicyManager: ServerTrustPolicyManager?
    
    internal var configuration: Configuration! {
        
        didSet {
            
            NetworkActivityLogger.shared.level = configuration.logLevel            
            
            switch configuration!.securityPolicy {
            case .none: break
            case .certifcatePinning:
                
                self.serverTrustPolicyManager = ServerTrustPolicyManager(policies: [configuration.baseUrl.host!: ServerTrustPolicy.pinPublicKeys(publicKeys: ServerTrustPolicy.publicKeys(), validateCertificateChain: true, validateHost: true)])
                
                configuration.sessionManager = Alamofire.SessionManager(
                    configuration: .ephemeral,
                    delegate: CertificatePinningSessionDelegate(),
                    serverTrustPolicyManager: self.serverTrustPolicyManager)
            }
        }
    }
    
    public var authorization: Authorization? {
        
        didSet {
            
            guard self.configuration != nil else { return }
            
            
        }
    }
}
