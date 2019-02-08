//
//  Configuration.swift
//  Alamofire
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

public class Configuration: NSObject {
    
    public let baseUrl: URL
    
    public let requestEncoder: JSONEncoder
    
    public let responseDecoder: JSONDecoder
    
    public let securityPolicy: SecurityPolicy
    
    public let timeout: TimeInterval
    
    public let logLevel: NetworkActivityLoggerLevel
    
    internal var sessionManager: Alamofire.SessionManager
    
    internal let responseQueue: DispatchQueue
    
    public init(
        baseUrl: URL,
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicy: SecurityPolicy = .none,
        timeout: TimeInterval = 5.0,
        logLevel: NetworkActivityLoggerLevel = .off,
        sessionManager: Alamofire.SessionManager = .default,
        responseQueue: DispatchQueue = .main
        ) {
        
        self.baseUrl =              baseUrl
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.securityPolicy =       securityPolicy
        self.timeout =              timeout
        self.logLevel =             logLevel
        self.sessionManager =       sessionManager
        self.responseQueue =        responseQueue
    }
}