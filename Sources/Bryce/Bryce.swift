//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Resolver

public enum Bryce {
                
    public static var config: Configuration = .default
        
    public static func use<T: Service>(_ service: T) {
        
        let options = Resolver.bryce.register { service }
        
        if service is DecodableErrorProviding {
            options.implements(DecodableErrorProviding.self)
        }
        service.setup()
    }
            
    public static func teardown() {
        config = .default
        authService?.teardown()
        networkLoggingService?.teardown()
        interceptors.removeAll()
        Resolver.bryce = Resolver()
    }
}

extension Bryce {
    
    static func log(_ items: Any...) {
        print("[Bryce]:", items)
    }
}
