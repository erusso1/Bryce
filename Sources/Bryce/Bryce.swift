//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger
import Resolver

public protocol Service {
    
    func setup()
    
    func teardown()
}

public struct NetworkLoggingService: Service {
    
    let logLevel: NetworkActivityLoggerLevel
    
    public init(logLevel: NetworkActivityLoggerLevel) {
        self.logLevel = logLevel
    }
    
    public func setup() {
        NetworkActivityLogger.shared.level = logLevel
        
        if logLevel != .off {
            NetworkActivityLogger.shared.startLogging()
        } else {
            NetworkActivityLogger.shared.stopLogging()
        }
    }
    
    public func teardown() {
        
        NetworkActivityLogger.shared.level = .off
        NetworkActivityLogger.shared.stopLogging()
    }
}

public final class AuthenticationService: Service {
    
    var authentication: Authorization? {
        didSet {
            let config = Bryce.config
            var headers = config.globalHeaders ?? [:]
            let key = Authorization.headerKey
            if let auth = authentication {
                headers[key] = auth.headerValue
            } else {
                headers[key] = nil
            }
            config.globalHeaders = headers
        }
    }
    
    public init() { }
    
    public func setup() { }
    
    public func teardown() {
        authentication = nil
    }
}

extension Bryce {
    
    static var authService: AuthenticationService { Resolver.bryce.resolve() }
    
    public static var auth: Authorization? {
        
        get { authService.authentication }
        
        set { authService.authentication = newValue }
    }
}

public enum Bryce {
                
    public static var config: Configuration = .default
        
    public static func use<T: Service>(_ service: T) {
        
        Resolver.bryce.register { service }
        service.setup()
    }
            
    public static func teardown() {
        
        config = .default
    }
}

func print(prefix: String = "[Bryce]", _ level: LogLevel, _ items: Any...) {
    
    if let logger = Bryce.config.customLogger {
        logger.log(prefix, level, items)
    }
    else {
        print(prefix, items)
    }
}
