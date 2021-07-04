//
//  SecurityPolicy.swift
//  Alamofire
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation
import Alamofire

public enum SecurityPolicy {
        
    case certifcatePinning(bundle: Bundle = .main, host: String)
    
    case publicKeyPinning(bundle: Bundle = .main, host: String)
    
    var policy: (host: String, evaluator: ServerTrustEvaluating) {
        switch self {
        case .certifcatePinning(let bundle, let host):
            return (host, PinnedCertificatesTrustEvaluator(certificates: bundle.af.certificates))
        case .publicKeyPinning(let bundle, let host):
            return (host, PublicKeysTrustEvaluator(keys: bundle.af.publicKeys))
        }
    }
}
