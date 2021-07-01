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
        
        Resolver.bryce.register { service }
        service.setup()
    }
            
    public static func teardown() {
        
        config = .default
    }
}
