//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityLogger

public enum Bryce {
            
    public private(set) static var configuration: Configuration = .default
    
    public private(set) static var url: URL?
    
    public static func use(_ config: Configuration) {
        
        configuration = config
        
        NetworkActivityLogger.shared.level = configuration.logLevel
        
        if configuration.logLevel != .off {
            NetworkActivityLogger.shared.startLogging()
        }
    }
    
    public static func use(_ auth: Authorization) {
        
        var headers = configuration.globalHeaders ?? [:]
        headers[Authorization.headerKey] = auth.headerValue
        configuration.globalHeaders = headers
    }
    
    public static func use(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        use(url)
    }
    
    public static func use(_ url: URL) {
        self.url = url
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
