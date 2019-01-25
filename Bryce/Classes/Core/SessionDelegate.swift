//
//  BRSessionDelegate.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/21/19.
//

import Foundation
import Alamofire

internal final class CertificatePinningSessionDelegate: Alamofire.SessionDelegate {
 
    override init() {
        super.init()
        
        self.sessionDidReceiveChallengeWithCompletion = { session, challenge, completion in
     
            // Ensure the challenge originates from the same host as that of the base URL.
            guard challenge.absoluteProtectionSpaceString == Bryce.shared.configuration.baseUrl.absoluteString else { completion(.performDefaultHandling, nil); return }
            
            // Ensure a trust exists for the challenged protection space.
            guard let trust = challenge.protectionSpace.serverTrust else { completion(.cancelAuthenticationChallenge, nil); return }
            
            // Obtain the set of public keys for each certificate found in the server.
            let serverPublicKeys = trust.publicKeys
            
            // Ensure the server has at least one certificate.
            guard !serverPublicKeys.isEmpty else { completion(.cancelAuthenticationChallenge, nil); return }
            
            // Ensure the bundle has at least one certificate to pin against.
            guard let localPublicKey: SecKey = pinnedCertificate()?.publicKey() else { completion(.cancelAuthenticationChallenge, nil); return }
            
            // Ensure there is at least one pinned certificate.
            guard serverPublicKeys.contains(localPublicKey) else { completion(.cancelAuthenticationChallenge, nil); return }
            
            // Execute the completionHandler using the credential.
            completion(.useCredential, URLCredential(trust: trust))
        }
    }
}

private func pinnedCertificate() -> SecCertificate?  {
    
    switch Bryce.shared.configuration.securityPolicy {
    case .none: return nil
    case .certifcatePinning(let path):
        guard let data = try? Data(contentsOf: path) as CFData else { return nil }
        return SecCertificateCreateWithData(nil, data)
    }
}

private extension SecTrust {
    
    var certificateCount: Int { return Int(SecTrustGetCertificateCount(self)) }
    
    var certificates: [SecCertificate] { return Array(0..<certificateCount).compactMap { SecTrustGetCertificateAtIndex(self, $0) } }
    
    var publicKeys: [SecKey] { return certificates.compactMap { $0.publicKey() } }
}

private extension SecCertificate {
    
    func publicKey() -> SecKey? {
        
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(self, policy, &trust)
        
        guard let trustOutput = trust, trustCreationStatus == errSecSuccess else { return nil }
        
        return SecTrustCopyPublicKey(trustOutput)
    }
}

private extension URLAuthenticationChallenge {
    
    var absoluteProtectionSpaceString: String { return "\(protectionSpace.protocol ?? "")://\(protectionSpace.host)" }
}
