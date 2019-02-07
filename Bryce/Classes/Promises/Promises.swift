//
//  Request.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation
import Alamofire
import PromiseKit

extension Bryce {
    
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> Promise<JSON> {
        
        return firstly {
            
            self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers ?? self.authorization?.headers).validate().responseJSON(queue: self.configuration.responseQueue)
            
            }.compactMap { data, response in
                data as? JSON
        }
    }
    
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> Promise<Array<JSON>> {
        
        return firstly {
            
            self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers ?? self.authorization?.headers).validate().responseJSON(queue: self.configuration.responseQueue)
            
            }.compactMap { data, response in
                data as? [JSON]
        }
    }
    
    public func request<D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, responseType: D.Type) -> Promise<D> {
        
        return self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers ?? self.authorization?.headers).validate().responseDecodable(queue: self.configuration.responseQueue, decoder: self.configuration.responseDecoder)
    }
    
    public func request<E: Encodable, D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, responseType: D.Type) -> Promise<D> {
        
        do {
            let data = try self.configuration.requestEncoder.encode(parameters)
            
            guard let params = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { throw EncodingError.invalidValue(parameters, .init(codingPath: [], debugDescription: "Unable to encode parameters: \(parameters)")) }
            
            return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, responseType: responseType)
        }
            
        catch { return Promise(error: error) }
    }
}
