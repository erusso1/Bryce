//
//  Configuration.swift
//  Alamofire
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

public final class Configuration {
        
    public let requestEncoder: JSONEncoder
    
    public let responseDecoder: JSONDecoder
        
    public let timeout: TimeInterval
        
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
        customLogger: LogCustomizable? = nil,
        globalHeaders: HTTPHeaders? = nil,
        acceptableStatusCodes: Range<Int> = 200..<400,
        responseQueue: DispatchQueue = .main
        ) {
        
        self.session =              session
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.timeout =              timeout
        self.customLogger =         customLogger
        self.globalHeaders =        globalHeaders
        self.acceptableStatusCodes = acceptableStatusCodes
        self.responseQueue =        responseQueue
    }
}

public extension Configuration {
    
    static var `default`: Configuration { .init() }
}
