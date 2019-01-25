//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Alamofire

public typealias JSON = [String : Any]

public final class Bryce: NSObject {
    
    public static let shared = Bryce()
    
    public func use(_ config: Configuration) { configuration = config }
    
    public func authenticate(_ auth: Authorization) { authorization = auth }
    
    public func logout() { authorization = nil }
    
    internal var configuration: Configuration! {
        
        didSet {
            
            switch configuration!.securityPolicy {
            case .none: break
            case .certifcatePinning:
                
                configuration.sessionManager = Alamofire.SessionManager(
                    configuration: .ephemeral,
                    delegate: CertificatePinningSessionDelegate(),
                    serverTrustPolicyManager: ServerTrustPolicyManager(policies: [configuration.baseUrl.host!: ServerTrustPolicy.pinPublicKeys(publicKeys: ServerTrustPolicy.publicKeys(), validateCertificateChain: true, validateHost: true) ])
                )
            }
        }
    }
    
    public var authorization: Authorization? {
        
        didSet {
            
            guard var configuration = configuration else { return }
            
            let manager = configuration.sessionManager
            let config = manager.session.configuration
            
            config.httpAdditionalHeaders = authorization?.headers
            
            configuration.sessionManager = Alamofire.SessionManager(
                configuration: config,
                delegate: manager.delegate,
                serverTrustPolicyManager: nil
            )
        }
    }
}
