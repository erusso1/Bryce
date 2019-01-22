//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation

public struct Bryce {
    
    public struct LogOptions: OptionSet {
        
        public static let requestEndpoint = LogOptions(rawValue: 1 << 0)
        public static let requestHeaders =  LogOptions(rawValue: 1 << 1)
        public static let requestBody =     LogOptions(rawValue: 1 << 2)
        public static let responseHeaders = LogOptions(rawValue: 1 << 3)
        public static let responseBody =    LogOptions(rawValue: 1 << 4)
        
        public static let all: LogOptions =     [.requestEndpoint, .requestHeaders, .requestBody, .responseHeaders, .responseBody]
        public static let debug: LogOptions =   [.requestEndpoint, .requestBody, .responseBody]
        
        public let rawValue: Int
        
        public init(rawValue: Int) { self.rawValue = rawValue }
    }
    
    public enum SecurityPolicy {
        
        case none
        
        case certifcatePinning(path: URL)
    }
    
    public struct Configuration {
        
        public let baseUrl: URL
        
        public let requestEncoder: JSONEncoder
        
        public let responseDecoder: JSONDecoder
        
        public let securityPolicy: SecurityPolicy
        
        public let timeout: TimeInterval
        
        public let logOptions: LogOptions
        
        public init(
            baseUrl: URL,
            requestEncoder: JSONEncoder = JSONEncoder(),
            responseDecoder: JSONDecoder = JSONDecoder(),
            securityPolicy: SecurityPolicy = .none,
            timeout: TimeInterval = 5.0,
            logOptions: LogOptions = []
        ) {
            
            self.baseUrl =          baseUrl
            self.requestEncoder =   requestEncoder
            self.responseDecoder =  responseDecoder
            self.securityPolicy =   securityPolicy
            self.timeout =          timeout
            self.logOptions =       logOptions
        }
    }
    
    public enum Authorization {
        
        case basic(username: String, password: String)
        
        case bearer(token: String)
        
        public var headers: [String : String] {
            
            switch self {
                
            case .basic(let username, let password):
                
                let token = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
                
                return ["Authorization" : "Basic \(token)"]
            
            case .bearer(let token):
                
                return ["Authorization" : "Bearer \(token)"]
            }
        }
    }
    
    public static var configuration: Configuration! {
        
        didSet {
            
            switch configuration.securityPolicy {
                
            case .none: session = URLSession.shared
            case .certifcatePinning:
                session = URLSession(
                    configuration: .ephemeral,
                    delegate: SessionDelegate(),
                    delegateQueue: nil
                )
            }
        }
    }
    
    public static var authorization: Authorization?
    
    internal static var session: URLSession!
}
