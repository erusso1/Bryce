//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/2/21.
//

import Alamofire
import Foundation
import Resolver

struct BryceRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        Bryce.interceptors.forEach { ($0 as? RequestInterceptor)?.adapt(urlRequest, for: session, completion: completion) }
    }
}

public extension Bryce {
    
    static var interceptors: [Any] = []
    
    static func intercept<T: RequestInterceptor>(using interceptor: T) {
        
        guard Thread.isMainThread else { fatalError("Attempted add an interceptor while not a the Main Thread.") }
                
        interceptors.append(interceptor)
    }
}
