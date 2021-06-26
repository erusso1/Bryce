//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

public typealias JSON = [String : Any]

public typealias BryceVoidHandler = () -> Void

public enum Bryce {
            
    public private(set) static var configuration: Configuration = .default
    
    public static func use(_ config: Configuration) {
        
        configuration = config
        
        NetworkActivityLogger.shared.level = configuration.logLevel
        
        if configuration.logLevel != .off {
            NetworkActivityLogger.shared.startLogging()
        }
    }
    
    public static func teardown() {
        
        configuration.globalHeaders = nil
        NetworkActivityLogger.shared.stopLogging()
    }
}

func print(prefix: String = "[Bryce]", _ level: LogLevel, _ items: Any...) {
    
    if let logger = Bryce.configuration.customLogger {
        logger.log(prefix, level, items)
    }
    else {
        print(prefix, items)
    }
}
