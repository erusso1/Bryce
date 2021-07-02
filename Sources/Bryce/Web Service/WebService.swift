//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import Foundation
import Alamofire

public protocol WebService {
    
    var client: WebClient { get }
    
    var requestModifier: Session.RequestModifier? { get }
}

public extension WebService {

    var requestModifier: Session.RequestModifier? { return nil }
}

public struct WebClient {
    
    private var url: URL?
    private var _responseDecoder: DataDecoder?
    private var _responseQueue: DispatchQueue?
        
    public init(urlString: String? = nil, responseDecoder: DataDecoder? = nil, responseQueue: DispatchQueue? = nil) {
        if let _urlString = urlString {
            self.url = URL(string: _urlString)
        } else {
            self.url = nil
        }
        
        self._responseDecoder = responseDecoder
        self._responseQueue = responseQueue
    }
    
    public var baseURL: URL {
        guard let url = self.url ?? Bryce.config.globalBaseURL else {
            assert(false, "No URL provided. A valid URL instance must be given to either Bryce or this instance of \(Self.self)")
        }
        return url
    }
}

extension WebClient {
    
    var session: Session { Bryce.config.session }
    
    func endpoint(path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }
    
    func requestHeaders(from headers: HTTPHeaders?) -> HTTPHeaders? {
        
        var headersToSend = headers ?? [:]
        headersToSend += Bryce.config.globalHeaders
        return headersToSend
    }
    
    var responseQueue: DispatchQueue {
        _responseQueue ?? Bryce.config.responseQueue
    }
    
    var responseDecoder: DataDecoder {
        _responseDecoder ?? Bryce.config.responseDecoder
    }
}

@inlinable
func +=(lhs: inout HTTPHeaders, rhs: HTTPHeaders) {
    for header in rhs {
        lhs[header.name] = header.value
    }
}
