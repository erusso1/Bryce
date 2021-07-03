//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/2/21.
//

import Alamofire
import Foundation
import Resolver

final class BryceRequestInterceptor: RequestInterceptor {
        
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        guard
            let interceptors = Array(Bryce.interceptors.values) as? [RequestInterceptor],
            !interceptors.isEmpty
        else { return completion(.success(urlRequest)) }

        var adaptedRequest = urlRequest
        var error: Error?
        let group = DispatchGroup()

        for interceptor in interceptors {
            
            guard error == nil else { break }
            
            group.enter()
            
            interceptor.adapt(adaptedRequest, for: session) { result in
                
                switch result {
                case .success(let request):
                    adaptedRequest = request
                case .failure(let adaptError):
                    error = adaptError
                }
                
                group.leave()
            }
          
            group.wait()
        }
        
        if let error = error { return completion(.failure(error)) }
        
        else { return completion(.success(adaptedRequest)) }
    }
}

public extension Bryce {
    
    static var interceptors: [AnyHashable: Any] = [:]
    
    static func intercept<T: RequestInterceptor>(using interceptor: T) {
        
        guard Thread.isMainThread else { fatalError("Attempted add an interceptor while not a the Main Thread.") }
        
        let id = ObjectIdentifier(T.self).hashValue
        
        interceptors[id] = interceptor
    }
}
