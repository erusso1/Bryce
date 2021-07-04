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
        urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.af.default,
        requestEncoder: JSONEncoder = JSONEncoder(),
        responseDecoder: JSONDecoder = JSONDecoder(),
        securityPolicies: [SecurityPolicy]? = nil,
        timeout: TimeInterval = 5.0,
        acceptableStatusCodes: Range<Int> = 200..<400,
        responseQueue: DispatchQueue = .main
        ) {
        
        let session = Alamofire.Session(configuration: urlSessionConfiguration, interceptor: Self.interceptor, serverTrustManager: trustManager(from: securityPolicies))
        
        self.globalBaseURLString =  globalBaseURLString
        self.session =              session
        self.requestEncoder =       requestEncoder
        self.responseDecoder =      responseDecoder
        self.timeout =              timeout
        self.acceptableStatusCodes = acceptableStatusCodes
        self.responseQueue =        responseQueue
    }
    
    public var globalBaseURL: URL? {
        guard let string = globalBaseURLString else { return nil }
        return URL(string: string)
    }
}

private func trustManager(from securityPolicies: [SecurityPolicy]?) -> ServerTrustManager? {
    
    guard let policies = securityPolicies, !policies.isEmpty else { return nil }

    var evaluators: [String: ServerTrustEvaluating] = [:]
    
    policies.forEach {
        let tuple = $0.policy
        evaluators[tuple.host] = tuple.evaluator
    }
    
    return ServerTrustManager(evaluators: evaluators)
}

public extension Configuration {
    
    static var `default`: Configuration { .init() }
}
