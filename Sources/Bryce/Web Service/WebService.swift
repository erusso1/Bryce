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
}

public final class WebClient {
    
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
}

extension WebClient {
    
    var session: Session { Bryce.configuration.session }

    public var baseURL: URL {
        guard let url = self.url ?? Bryce.url else {
            assert(false, "No URL provided. A valid URL instance must be given to either Bryce or this instance of \(Self.self)")
        }
        return url
    }
    
    func requestHeaders(from headers: HTTPHeaders?) -> HTTPHeaders? {
        
        var headersToSend = headers ?? [:]
        if let globalHeaders = Bryce.configuration.globalHeaders {
            headersToSend += globalHeaders
        }
        return headersToSend
    }
    
    var responseQueue: DispatchQueue {
        _responseQueue ?? Bryce.configuration.responseQueue
    }
    
    var responseDecoder: DataDecoder {
        _responseDecoder ?? Bryce.configuration.responseDecoder
    }
}

@inlinable
func +=(lhs: inout HTTPHeaders, rhs: HTTPHeaders) {
    for header in rhs {
        lhs[header.name] = header.value
    }
}
