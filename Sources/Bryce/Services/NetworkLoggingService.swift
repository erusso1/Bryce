//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import Foundation
import AlamofireNetworkActivityLogger
import Resolver

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
