//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Alamofire
import Foundation

public enum Authorization {
    
    case basic(username: String, password: String)
    
    case bearer(token: String)
    
    public var headerValue: String {
        
        switch self {
        case .basic(let username, let password):
            
            let token = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
            return "Basic \(token)"
            
        case .bearer(let token):
            return "Bearer \(token)"
        }
    }    
}

final class AuthorizationAdapter: RequestAdapter {
    
    private let authorization: Authorization
    
    init(authorization: Authorization) {
        self.authorization = authorization
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var urlRequest = urlRequest
        
        if urlRequest.url?.host == Bryce.shared.configuration.baseUrl.host {
           
            urlRequest.setValue(authorization.headerValue, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
