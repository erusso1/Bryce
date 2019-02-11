//
//  Request.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/22/19.
//

import Foundation
import Alamofire
import CodableAlamofire

public typealias ErrorResponse = (Error?) -> Void

public typealias JSONResponse = (JSON?, Error?) -> Void

public typealias JSONArrayResponse = (Array<JSON>?, Error?) -> Void

public typealias DecodableResponse<D: Decodable> = (D?, Error?) -> Void

extension Bryce {
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping ErrorResponse) -> DataRequest {
        
        return self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().response(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let error = alamofireResponse.error
            
            response(error)
        }
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping JSONResponse) -> DataRequest {
        
        return self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let json = alamofireResponse.result.value as? [String : Any]
            let error = alamofireResponse.result.error
            
            response(json, error)
        }
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping JSONArrayResponse) -> DataRequest {
        
        return self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let array = alamofireResponse.result.value as? Array<[String : Any]>
            let error = alamofireResponse.result.error
            
            response(array, error)
        }
    }
}

extension Bryce {
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping ErrorResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping JSONResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping JSONArrayResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, response: response)
    }
}

extension Bryce {
    
    @discardableResult
    public func request<D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        return self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseDecodableObject(queue: self.configuration.responseQueue, decoder: self.configuration.responseDecoder) { (alamofireResponse: DataResponse<D>) in
            
            let decodable = alamofireResponse.result.value
            let error = alamofireResponse.result.error
            
            response(decodable, error)
        }
    }
    
    @discardableResult
    public func request<E: Encodable, D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, response: response)
    }
}
