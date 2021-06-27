//
//  BryceLogger.swift
//  BryceNetworking
//
//  Created by Ephraim Russo on 3/3/20.
//

import Foundation

public enum LogLevel {
    
    case debug
    case info
    case warning
    case error
}


public protocol LogCustomizable {
    
    func log(_ prefix: String, _ level: LogLevel, _ items: Any...)
}
