//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/3/21.
//

import Foundation
import Bryce
import Resolver

extension Bryce {
    
    static func use(urlProtocol: AnyClass) {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [urlProtocol]
        Bryce.config = .init(urlSessionConfiguration: config)
    }
}
