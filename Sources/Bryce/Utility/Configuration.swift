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
    
    public let acceptableStatusCodes: Range<Int>

    public let session: Session
    
    public let responseQueue: DispatchQueue
    
    private static let interceptor = BryceRequestInterceptor()
    
    public init(
        _ globalBaseURLString: String? = nil,
        session: Alamofire.Session,
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicy: SecurityPolicy = .none,
        timeout: TimeInterval = 5.0,
        acceptableStatusCodes: Range<Int> = 200..<400,
        responseQueue: DispatchQueue = .main
        ) {
        
        self.globalBaseURLString =  globalBaseURLString
        self.session =              session
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.timeout =              timeout
        self.acceptableStatusCodes = acceptableStatusCodes
        self.responseQueue =        responseQueue
    }
    
    public convenience init(
        _ globalBaseURLString: String? = nil,
        urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.af.default,
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicy: SecurityPolicy = .none,
        timeout: TimeInterval = 5.0,
        acceptableStatusCodes: Range<Int> = 200..<400,
        responseQueue: DispatchQueue = .main
        ) {
        
        let session = Alamofire.Session(configuration: urlSessionConfiguration, interceptor: Self.interceptor, serverTrustManager: nil)
        
        self.init(globalBaseURLString, session: session, requestEncoder: requestEncoder, responseDecoder: responseDecoder, securityPolicy: securityPolicy, timeout: timeout, acceptableStatusCodes: acceptableStatusCodes, responseQueue: responseQueue)
    }
    
    public var globalBaseURL: URL? {
        guard let string = globalBaseURLString else { return nil }
        return URL(string: string)
    }
}

public extension Configuration {
    
    static var `default`: Configuration { .init() }
}
