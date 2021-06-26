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
        
    public let requestEncoder: JSONEncoder
    
    public let responseDecoder: JSONDecoder
        
    public let timeout: TimeInterval
    
    public let logLevel: NetworkActivityLoggerLevel
    
    public let customLogger: LogCustomizable?
    
    public var globalHeaders: [String: String]?
    
    public let acceptableStatusCodes: Range<Int>

    public var session: Session
    
    public let responseQueue: DispatchQueue
    
    public init(
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicy: SecurityPolicy = .none,
        timeout: TimeInterval = 5.0,
        logLevel: NetworkActivityLoggerLevel = .debug,
        customLogger: LogCustomizable? = nil,
        globalHeaders: [String: String]? = nil,
        acceptableStatusCodes: Range<Int> = 200..<400,
        session: Alamofire.Session = .default,
        responseQueue: DispatchQueue = .main
        ) {
        
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.timeout =              timeout
        self.logLevel =             logLevel
        self.customLogger =         customLogger
        self.globalHeaders =        globalHeaders
        self.acceptableStatusCodes = acceptableStatusCodes
        self.session =              session
        self.responseQueue =        responseQueue
    }
}

extension Configuration {
    
    static let `default`: Configuration = .init()
}
