//
//  Request.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/22/19.
//

import Foundation
import PromiseKit

extension Bryce {
    
    public typealias Response = Promise<(data: Data, response: URLResponse)>
    
    public enum Method: String {
        
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    public enum ParameterEncoding {
        
        case httpBody
        case query
    }
}

private extension URLRequest {

    static func request<T: Encodable>(with url: URL, method: Bryce.Method, parameters: T? = nil, encoding: Bryce.ParameterEncoding = .httpBody, timeout: TimeInterval = Bryce.configuration.timeout) throws -> URLRequest {
        
        var req = URLRequest(url: url, timeoutInterval: timeout)
        req.httpMethod = method.rawValue
        try req.encode(parameters: parameters, encoding: encoding)
        return req
    }
    
    mutating func encode<T: Encodable>(parameters: T?, encoding: Bryce.ParameterEncoding) throws {
        
        guard let parameters = parameters else { return }
        
        switch encoding {
            
        case .httpBody:
            guard httpMethod != Bryce.Method.get.rawValue else { return }
            self.httpBody = try Bryce.configuration.requestEncoder.encode(parameters)
            
        case .query:
            guard var comps = self.url?.components else { return }
            let json = try JSONSerialization.jsonObject(with: try Bryce.configuration.requestEncoder.encode(parameters), options: .allowFragments)
            switch json {
                
            case let stringMap as [String : String]: comps.queryItems = stringMap.map { URLQueryItem(name: $0.key, value: $0.value) }
            case let stringArray as [String : [String]]:
                var queryItems: [URLQueryItem] = []
                stringArray.forEach { key, value in
                    for (i, item) in value.enumerated() {
                        queryItems.append(URLQueryItem(name: key + "[\(i)]", value: item))
                    }
                }
                
                comps.queryItems = queryItems
            default: break
            }
            self.url = comps.url
        }
    }
}

private extension URL {
    
    var components: URLComponents? { return URLComponents(url: self, resolvingAgainstBaseURL: true) }
}

extension Bryce {
    
    public static func request<T: Encodable>(url: URL, method: Method = .get, parameters: T? = nil, encoding: Bryce.ParameterEncoding = .httpBody) throws -> Response {
        
        return session!.dataTask(.promise, with: try URLRequest.request(with: url, method: method, parameters: parameters, encoding: encoding)).validate()
    }
}
