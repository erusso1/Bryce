//
//  Configuration.swift
//  Alamofire
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

public struct Configuration {
        
    public let requestEncoder: JSONEncoder
    
    public let responseDecoder: JSONDecoder
        
    public let timeout: TimeInterval
    
    public let logLevel: NetworkActivityLoggerLevel
    
    public let customLogger: LogCustomizable?
    
    public var globalHeaders: HTTPHeaders?
    
    public let acceptableStatusCodes: Range<Int>

    public var session: Session
    
    public let responseQueue: DispatchQueue
    
    public init(
        session: Alamofire.Session = .default,
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicy: SecurityPolicy = .none,
        timeout: TimeInterval = 5.0,
        logLevel: NetworkActivityLoggerLevel = .debug,
        customLogger: LogCustomizable? = nil,
        globalHeaders: HTTPHeaders? = nil,
        acceptableStatusCodes: Range<Int> = 200..<400,
        responseQueue: DispatchQueue = .main
        ) {
        
        self.session =              session
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.timeout =              timeout
        self.logLevel =             logLevel
        self.customLogger =         customLogger
        self.globalHeaders =        globalHeaders
        self.acceptableStatusCodes = acceptableStatusCodes
        self.responseQueue =        responseQueue
    }
}

extension Configuration {
    
    static let `default`: Configuration = .init()
}
