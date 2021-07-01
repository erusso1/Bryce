//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import Foundation
import Resolver

public final class AuthenticationService: Service {
    
    var auth: Authentication? {
        didSet {
            let config = Bryce.config
            var headers = config.globalHeaders ?? [:]
            let key = Authentication.headerKey
            if let auth = self.auth {
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
        auth = nil
    }
}

extension Bryce {
    
    static var authService: AuthenticationService { Resolver.bryce.resolve() }
    
    public static var auth: Authentication? {
        
        get { authService.auth }
        
        set { authService.auth = newValue }
    }
}
