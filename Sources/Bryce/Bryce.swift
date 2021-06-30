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
    
    public var authentication: Authorization? {
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

public extension Bryce {
    
    static var authentication: AuthenticationService { Resolver.bryce.resolve() }
}

public enum Bryce {
                
    public static var config: Configuration = .default

    public private(set) static var url: URL?
        
    public static func use<T: Service>(_ service: T) {
        
        Resolver.bryce.register { service }
        service.setup()
    }
    
    public static func use(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        use(url)
    }
    
    public static func use(_ url: URL) {
        self.url = url
    }
    
    public static func teardown() {
        url = nil
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
