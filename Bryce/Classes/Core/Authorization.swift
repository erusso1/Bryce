//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation

public enum Authorization {
    
    case basic(username: String, password: String)
    
    case bearer(token: String)
    
    public var headers: [String : String] {
        
        switch self {
            
        case .basic(let username, let password):
            
            let token = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
            return ["Authorization" : "Basic \(token)"]
            
        case .bearer(let token):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
}
