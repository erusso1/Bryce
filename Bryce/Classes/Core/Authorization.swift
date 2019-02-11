//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Alamofire
import Foundation

public class Authorization: NSObject, Codable {
    
    public let headerValue: String
    
    public let headerKey = "Autorization"
    
    public init(headerValue: String) {
        self.headerValue = headerValue
        super.init()
    }
}

extension Authorization {
    
    public static func basic(username: String, password: String) -> Authorization {
        
        let token = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        return Authorization(headerValue: "Basic \(token)")
    }
    
    public static func bearer(token: String) -> Authorization {
        
        return Authorization(headerValue: "Bearer \(token)")
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
