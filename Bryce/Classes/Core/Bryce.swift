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

public final class Bryce: NSObject {
    
    public static let shared = Bryce()
        
    public override init() {
        super.init()
    }

    public private(set) var configuration: Configuration!
}

extension Bryce {
    
    public func use(_ config: Configuration) {
        
        configuration = config
        
        NetworkActivityLogger.shared.level = configuration.logLevel
        
        if configuration.logLevel != .off {
            NetworkActivityLogger.shared.startLogging()
        }
    }
    
    public func teardown() { }
}

extension Bryce {
    
    internal func log(prefix: String = "[Bryce]", _ level: LogLevel, _ items: Any...) {
        
        if let logger = configuration.customLogger {
            logger.log(prefix, level, items)
        }
        else {
            print("\(prefix) \(items)")
        }
    }
}
