//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import Foundation
import Resolver

public final class AuthenticationService: Service {
    
    var authentication: Authorization? {
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

extension Bryce {
    
    static var authService: AuthenticationService { Resolver.bryce.resolve() }
    
    public static var auth: Authorization? {
        
        get { authService.authentication }
        
        set { authService.authentication = newValue }
    }
}
