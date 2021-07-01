//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Alamofire
import Foundation

public enum Authentication {
    
    case basic(username: String, password: String)
    
    case bearer(token: String, expiration: Date)
    
    static let headerKey = "Authorization"
    
    var headerValue: String {
        switch self {
        case .basic(let username, let password): return "Basic \((username + ":" + password).data(using: .utf8)!.base64EncodedString())"
        case .bearer(let token, _): return "Bearer \(token)"
        }
    }
}
