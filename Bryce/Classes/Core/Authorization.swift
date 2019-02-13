//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Alamofire
import Foundation

public enum AuthorizationType: String, Codable {
    
    case basic
    
    case bearer
}

public class Authorization: NSObject, Codable {
    
    static let headerKey = "Authorization"
    
    public var headerValue: String {
        
        switch type {
        case .basic: return "Basic \(token)"
        case .bearer: return "Bearer \(token)"
        }
    }

    public let type: AuthorizationType
    
    public let token: String
    
    public let refreshToken: String?
    
    public init(type: AuthorizationType, token: String, refreshToken: String?) {
        self.type = type
        self.token = token
        self.refreshToken = refreshToken
        super.init()
    }
}

extension Authorization {
    
    public static func basic(username: String, password: String) -> Authorization {
        
        let token = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        return Authorization(type: .basic, token: token, refreshToken: nil)
    }
    
    public static func bearer(token: String, refreshToken: String?) -> Authorization {
        
        return Authorization(type: .bearer, token: token, refreshToken: refreshToken)
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
