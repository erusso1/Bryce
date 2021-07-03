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
    
    private var interceptors: [RequestInterceptor]? {
        Array(Bryce.interceptors.values) as? [RequestInterceptor]
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        adapt(urlRequest, for: session, using: interceptors ?? [], completion: completion)
    }
    
    private func adapt(_ urlRequest: URLRequest,
                       for session: Session,
                       using adapters: [RequestAdapter],
                       completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var pendingAdapters = adapters

        guard !pendingAdapters.isEmpty else { completion(.success(urlRequest)); return }

        let adapter = pendingAdapters.removeFirst()

        adapter.adapt(urlRequest, for: session) { result in
            switch result {
            case let .success(urlRequest):
                self.adapt(urlRequest, for: session, using: pendingAdapters, completion: completion)
            case .failure:
                completion(result)
            }
        }
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
