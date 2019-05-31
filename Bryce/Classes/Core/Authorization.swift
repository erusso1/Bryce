//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Alamofire
import Foundation
import KeychainAccess

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
    
    public let expiration: Date?
    
    public init(type: AuthorizationType, token: String, refreshToken: String?, expiration: Date?) {
        self.type = type
        self.token = token
        self.refreshToken = refreshToken
        self.expiration = expiration
        super.init()
    }
}

extension Authorization {
    
    public static func basic(username: String, password: String, expiration: Date?) -> Authorization {
        
        let token = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        return Authorization(type: .basic, token: token, refreshToken: nil, expiration: expiration)
    }
    
    public static func bearer(token: String, refreshToken: String?, expiration: Date?) -> Authorization {
        
        return Authorization(type: .bearer, token: token, refreshToken: refreshToken, expiration: expiration)
    }
}

final class AuthorizationMiddleware {
        
    internal let authorization: Authorization
    
    init(authorization: Authorization) {
        self.authorization = authorization
    }
}

extension AuthorizationMiddleware: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var urlRequest = urlRequest
        
        if urlRequest.url?.host == Bryce.shared.configuration.baseUrl.host {
            
            urlRequest.setValue(authorization.headerValue, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

extension AuthorizationMiddleware: RequestRetrier {
    
    // See https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#adapting-and-retrying-requests
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            
            Bryce.shared.configuration?.unauthorizedResponseHandler?()
            
            completion(false, 0.0)
        }
        
        else { completion(false, 0.0) }
    }
}
