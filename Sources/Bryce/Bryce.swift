//
//  Bryce.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/20/19.
//

import Foundation
import Resolver

public enum Bryce {
    
    static var services: [AnyHashable: Any] = [:]
                
    public static var config: Configuration = .default
        
    public static func use<T: Service>(_ service: T) {
        
        guard Thread.isMainThread else { fatalError("Attempted use service while not on the Main Thread.") }
        
        let id = ObjectIdentifier(T.self).hashValue
        
        services[id] = service
        
        let options = Resolver.bryce.register { service }
        
        if service is DecodableErrorProviding {
            options.implements(DecodableErrorProviding.self)
        }
        service.setup()
    }
            
    public static func teardown() {
        
        services.values
            .compactMap { $0 as? Service }
            .forEach { $0.teardown() }
        
        services.removeAll()
        interceptors.removeAll()

        Resolver.bryce = Resolver()
        
        config = .default
    }
}

extension Bryce {
    
    static func log(_ items: Any...) {
        print("[Bryce]:", items)
    }
}
