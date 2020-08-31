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
    
    private var isRefreshing = false
    
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    private let lock = NSLock()
    
    private let maxRetryCount = 1
    
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
        
        if let globalHeaders = Bryce.shared.configuration.globalHeaders {
            
            for (key, value) in globalHeaders {
                
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return urlRequest
    }
}

extension AuthorizationMiddleware: RequestRetrier {
    
    // See https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#adapting-and-retrying-requests
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        // The response is 401 'Unauthorized'. Attempt to retry using retry handler.
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, request.retryCount < maxRetryCount, let urlRequest = request.request else { return completion(false, 0.0) }
        
        // Check if the client has implemented a refresh handler. Otherwise, immediately fail.
        guard let handler = Bryce.shared.configuration?.authorizationRefreshHandler else { return completion(false, 0.0) }
        
        // Append the completion handler to the array of captured 401 requests.
        requestsToRetry.append(completion)
        
        // Check if there is already a fresh request in progress.
        guard !isRefreshing else { return completion(false, 0.0) }
        
        // Set the lock.
        isRefreshing = true
        
        // Perform the handler.
        handler(urlRequest) { [weak self] in
            
            guard let strongSelf = self else { return completion(false, 0.0) }
            
            strongSelf.lock.lock()
            
            defer { strongSelf.lock.unlock() }
            
            strongSelf.requestsToRetry.forEach { $0(true, 0.0) }
            strongSelf.requestsToRetry.removeAll()
            
            // Unlock
            strongSelf.isRefreshing = false
        }
    }
}
