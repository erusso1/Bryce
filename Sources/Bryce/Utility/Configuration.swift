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
        
    public let globalBaseURLString: String?
    
    public let requestEncoder: JSONEncoder
    
    public let responseDecoder: JSONDecoder
        
    public let timeout: TimeInterval
    
    public var globalHeaders: HTTPHeaders?
    
    public let acceptableStatusCodes: Range<Int>

    public var session: Session
    
    public let responseQueue: DispatchQueue
    
    public init(
        _ globalBaseURLString: String? = nil,
        session: Alamofire.Session = .default,
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicy: SecurityPolicy = .none,
        timeout: TimeInterval = 5.0,
        globalHeaders: HTTPHeaders? = nil,
        acceptableStatusCodes: Range<Int> = 200..<400,
        responseQueue: DispatchQueue = .main
        ) {
        
        self.globalBaseURLString =  globalBaseURLString
        self.session =              session
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.timeout =              timeout
        self.globalHeaders =        globalHeaders
        self.acceptableStatusCodes = acceptableStatusCodes
        self.responseQueue =        responseQueue
    }
    
    public var globalBaseURL: URL? {
        guard let string = globalBaseURLString else { return nil }
        return URL(string: string)
    }
}

public extension Configuration {
    
    static var `default`: Configuration { .init() }
}
