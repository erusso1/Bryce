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
    
    public init(url: URL? = nil) {
        self.url = url
    }
    
    private var session: Session { Bryce.configuration.session }
    
    private func url(endpoint: Endpoint) -> URL {
        guard let url = endpoint.url ?? self.url ?? Bryce.url else {
            assert(false, "No URL provided. A valid URL instance must be given to either Bryce, \(Self.self), or the endpoint \(endpoint)")
        }
        return url
    }
    
    public func get<E: Encodable>(endpoint: Endpoint, parameters: E?, headers: HTTPHeaders?) -> DataRequest {
        
        session.request(url(endpoint: endpoint), method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
    }
    
    public func request(endpoint: Endpoint) {
    
    }
}
